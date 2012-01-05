# About

DMLT is a Machine Learning toolbox written in Matlab and C. This toolbox is developed at the Donders Institute for Brain, Cognition and Behaviour and provides a general interface to support the integration of new statistical machine learning methods by writing high level wrappers. It allows complex methods to be built from simple building blocks and makes the use of cross-validation and permutation testing as easy as writing one line of Matlab code. The code requires at least Matlab distribution 7.6.0.324 (R2008a).

Most functions in this toolbox are licensed under the GNU General Public License (GPL), see http://www.gnu.org for details. Unauthorised copying and distribution of functions that are not explicitely covered by the GPL is not allowed.

# Installation

DMLT can be installed by cloning the repository:

	git clone git://github.com/DMLT/DMLT.git

or, if you have write privileges, using:

	git clone git@github.com:DMLT/DMLT.git

DMLT documentation is added automatically to the Matlab help facility when adding DMLT to the search path, e.g. using:

	addpath(genpath(pwd));

assuming you start your Matlab session in the DMLT root folder.

# Documentation

Documentation is available through the Matlab help facility but can also be consulted [here](http://marcelge.github.com/DMLT)

# Developers

Marcel van Gerven (m.vangerven@donders.ru.nl), Ali Bahramisharif (ali@cs.ru.nl), Jason Farquhar (j.farquhar@donders.ru.nl), Tom Heskes (tomh@cs.ru.nl)
