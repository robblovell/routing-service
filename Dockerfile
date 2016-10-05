FROM node:6.7.0-onbuild
ONBUILD ENV PORT 3000
ONBUILD RUN npm install
ONBUILD RUN npm install gulp -g
ONBUILD RUN npm install coffee-script -g
ONBUILD RUN gulp build