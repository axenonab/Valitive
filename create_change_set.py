import os
import sys
import argparse
import shutil
from lxml import etree


FILE_PATH = os.path.dirname(os.path.abspath(__file__))
APEX_CLASSES_PATH = os.path.join(FILE_PATH, 'force-app', 'main', 'default', 'classes')
APEX_TRIGGER_PATH = os.path.join(FILE_PATH, 'force-app', 'main', 'default', 'triggers')
FLOWS_PATH = os.path.join(FILE_PATH, 'force-app', 'main', 'default', 'flows')
OBJECTS_PATH = os.path.join(FILE_PATH, 'force-app', 'main', 'default', 'objects')
TARGET_DIR = os.path.join(FILE_PATH, 'toDeploy')

def generate_deployment_dir(files):
    if not os.path.exists(TARGET_DIR):
        os.mkdir(TARGET_DIR)
    print('*** Change Set Directory created: ./toDeploy')
    for key, value in files.items():
        if value:
            FILES_TO_FIND = [file.strip() for file in value.split(',')]
            if key == 'apex_classes':
                find_and_copy_apex(APEX_CLASSES_PATH, TARGET_DIR, FILES_TO_FIND)
            elif key == 'apex_triggers':
                find_and_copy_apex(APEX_TRIGGER_PATH, TARGET_DIR, FILES_TO_FIND)
            elif key == 'flows':
                find_and_copy_flow(FLOWS_PATH, TARGET_DIR, FILES_TO_FIND)
            else:
                find_and_copy_object(OBJECTS_PATH, TARGET_DIR, FILES_TO_FIND)
    print("*** FILES IN DEPLOY DIRECOTRY ***")
    print(os.listdir(TARGET_DIR))
    # print('*** GENERATE PACKAGE.XML ***')
    # create_package_xml(files)
    # print('*** DONE ***')
    # shutil.make_archive(TARGET_DIR, 'zip', TARGET_DIR)


def find_and_copy_apex(file_directory, target_directory, files_to_find):
    for file in os.listdir(file_directory):
        filename = os.path.splitext(file)[0]
        if filename in files_to_find:
            file_path = os.path.join(file_directory, file)
            xml_file = os.path.join(file_directory, f"{filename}.cls-meta.xml")
            shutil.copy(file_path, target_directory)
            shutil.copy(xml_file, target_directory)

def find_and_copy_flow(file_directory, target_directory, files_to_find):
    for file in os.listdir(file_directory):
        filename = file.split('.')[0]
        if filename in files_to_find:
            xml_file = os.path.join(file_directory, f"{filename}.flow-meta.xml")
            shutil.copy(xml_file, target_directory)

def find_and_copy_object(file_directory, target_directory, files_to_find):
    for file in os.listdir(file_directory):
        if file in files_to_find:
            xml_file = os.path.join(file_directory, file, f"{file}.object-meta.xml")
            shutil.copy(xml_file, target_directory)

def create_package_xml(files):
    OUTPUT_FILE = os.path.join(TARGET_DIR, 'package.xml')
    # if not os.path.isfile(OUTPUT_FILE):
    #       with open(OUTPUT_FILE, 'w'): pass
    # Create the root element
    package = etree.Element('Package', {'xmlns': "http://soap.sforce.com/2006/04/metadata"})
    for file_type, file_names in files.items():
        if file_names:
            FILES_TO_FIND = [file.strip() for file in file_names.split(',')]
            if file_type == 'apex_classes' and FILES_TO_FIND:
                #ApexClasses
                ApexClasses = etree.SubElement(package, 'types')
                name = etree.SubElement(ApexClasses, 'name')
                name.text = 'ApexClass'
                for file in FILES_TO_FIND:
                    name = etree.SubElement(ApexClasses, 'members')
                    name.text = file
            elif file_type == 'apex_triggers' and FILES_TO_FIND:
                #ApexTriggers
                ApexTriggers = etree.SubElement(package, 'types')
                name = etree.SubElement(ApexTriggers, 'name')
                name.text = 'ApexTrigger'
                for file in FILES_TO_FIND:
                    name = etree.SubElement(ApexTriggers, 'members')
                    name.text = file            
            elif file_type == 'flows' and FILES_TO_FIND:
                #Flows
                Flows = etree.SubElement(package, 'types')
                name = etree.SubElement(Flows, 'name')
                name.text = 'Flow'
                for file in FILES_TO_FIND:
                    name = etree.SubElement(Flows, 'members')
                    name.text = file            
            elif file_type == 'objects' and FILES_TO_FIND:
                # Objects
                Objects = etree.SubElement(package, 'types')
                name = etree.SubElement(Objects, 'name')
                name.text = 'CustomObject'
                for file in FILES_TO_FIND:
                    name = etree.SubElement(Objects, 'members')
                    name.text = file
    # Version
    version = etree.SubElement(package, 'version')
    version.text = '55.0'
    doc = etree.ElementTree(package)
    print(etree.tostring(doc, pretty_print=True))
    doc.write(OUTPUT_FILE, pretty_print=True, xml_declaration = True, encoding='UTF-8', standalone=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--apex_classes')
    parser.add_argument('--apex_triggers')
    parser.add_argument('--flows')
    parser.add_argument('--objects')
    args = parser.parse_args()
    apex_classes = args.apex_classes
    apex_triggers = args.apex_triggers
    flows = args.flows
    objects = args.objects
    files = {'apex_classes': apex_classes, 'apex_triggers': apex_triggers, 'flows': flows, 'objects': objects}
    test = generate_deployment_dir(files)
