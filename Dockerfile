FROM node:6.7.0-onbuild
ONBUILD ENV PORT 3000
ONBUILD RUN npm install
ONBUILD RUN gulp build