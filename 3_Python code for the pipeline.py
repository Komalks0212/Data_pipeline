import logging

# to-do: make a separate module and import it here
# Function to handle exceptions, if any
logging.basicConfig(
    filename=r'D:\Work\Clinical project\logs\logs.log',
    encoding='utf-8', level=logging.DEBUG, format='%(asctime)s %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s')

import csv
import os
# import sys
import psycopg2
import datetime

def get_delim():
    try:
        configfile = r'D:\Work\Clinical project\Dataload.config.txt'
        with open(configfile, "r") as contents:
            for line in contents:
                if line.find("delimiter =") != -1:
                    delim_loc = (line.find("delimiter =")) + 11
                    delim = (line[delim_loc:]).strip()
                    contents.close()
                    return delim

        return '~*~'

    except Exception as err:
        logging.error(err)


def proc_load_data_into_db():
    main_folder_path = r'D:\Work\Clinical project\load'
    error_folder_path = r'D:\Work\Clinical project\error_files'
    processed_folder_path = r'D:\Work\Clinical project\processed'

    delim = ''
    batch_status = 'C'

    logging.info('Running Python code')

    db_user = 'postgres'
    db_password = 'Welcome1!'
    db_host = 'localhost'
    db_port = '5432'
    db_name = 'clinical_db'

    connection = psycopg2.connect(user=db_user, password=db_password, host=db_host, port=db_port, database=db_name)
    connection.autocommit = True
    cur = connection.cursor()

    try:
        delim = get_delim()
        if delim == '':
            logging.info('Delimiter is not specified in config file. Please update that and run the code again.')
            print('Delimiter is not specified in config file.')
            exit()

        if delim == '\\t':
            delim1 = '\t'
        else:
            delim1 = delim

        # connected_to_pg = True
        # connect_to_postgres()


        for file in os.listdir(main_folder_path):
            now = datetime.datetime.now()
            current_time = now.strftime("_%Y%m%d-%H_%M_%S")
            inputfile = os.path.join(main_folder_path, file)

            header = []
            copy_str = ''
            copy_col = ''
            load_id = 0

            try:
                with open(inputfile, 'r') as inFile:
                    current_file = csv.reader(inFile, delimiter=delim1)
                    # skip the first row from the reader
                    header = next(current_file, None)
                    # check length and throw error if > 100
                    for i in range(1, len(header) + 1):
                        copy_col = copy_col + 'column' + str(i) + ', '

                    copy_str = 'copy staging.generic_load_table(' + copy_col[
                                                              :-2] + ') FROM STDIN with CSV delimiter as E\'' + delim1 + '\' ;'
                    # print(copy_str)

                with open(inputfile, 'r') as inFile:
                    # current_file = csv.reader(inFile, delimiter=delim1)
                    call_proc = 'call staging.proc_load_file_into_db(pvi_table_name:= %s);'
                    cur.execute(call_proc, [file])
                    result = cur.fetchone()[0]
                    cur.copy_expert(copy_str, inFile)
                    # processing_successful = True

            except Exception as err:
                os.replace(os.path.join(main_folder_path, file), os.path.join(error_folder_path, (
                            file.split('.')[0] + current_time + '.' + file.split('.')[1])))

                logging.error('Error while processing/loading file ' + file + ' into PG')
                logging.exception(err)
                continue

            if result == 'N':
                os.replace(os.path.join(main_folder_path, file), os.path.join(error_folder_path, (
                            file.split('.')[0] + current_time + '.' + file.split('.')[1])))
                logging.info('File ' + file + ' was not processed successfully')
            else:
                os.replace(os.path.join(main_folder_path, file), os.path.join(processed_folder_path, (
                            file.split('.')[0] + current_time + '.' + file.split('.')[1])))
                logging.info('File ' + file + ' was processed successfully')

        #  closing connection cursor
        if connection:
            cur.close()
            connection.close()
            logging.info("PostgreSQL connection is closed")

    except Exception as err:

        logging.exception(err)

        if connection is False:
            cur = connection.cursor()

        cur.close()
        # connection = None

    finally:
        if connection:
            connection.close()
            connection = None


proc_load_data_into_db()
