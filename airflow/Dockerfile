FROM puckel/docker-airflow:1.10.7

USER root

COPY airflow.cfg ./airflow.cfg
COPY /dags ./dags

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY requirements.txt /requirements.txt
RUN pip install boto3
RUN pip install --upgrade pip

# COPY EMR-key-pair.pem /usr/local/airflow/.ssh/EMR-key-pair.pem
# RUN chown -R airflow:airflow /usr/local/airflow/.ssh/EMR-key-pair.pem
# Add directory in which pip installs to PATH
ENV PATH="/usr/local/airflow/.local/bin:${PATH}"

USER airflow


ENTRYPOINT ["/entrypoint.sh"]

# Just for documentation. Expose webserver, worker and flower respectively
EXPOSE 8080
EXPOSE 8793
EXPOSE 5555