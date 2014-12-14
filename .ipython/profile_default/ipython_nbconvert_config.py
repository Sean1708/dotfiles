# Configuration file for ipython-nbconvert.

c = get_config()

#------------------------------------------------------------------------------
# NbConvertApp configuration
#------------------------------------------------------------------------------

# This application is used to convert notebook files (*.ipynb) to various other
# formats.
# 
# WARNING: THE COMMANDLINE INTERFACE MAY CHANGE IN FUTURE RELEASES.

# NbConvertApp will inherit config from: BaseIPythonApplication, Application

# Create a massive crash report when IPython encounters what may be an internal
# error.  The default is to append a short message to the usual traceback
# c.NbConvertApp.verbose_crash = False

# Whether to create profile dir if it doesn't exist
# c.NbConvertApp.auto_create = False

# The name of the IPython directory. This directory is used for logging
# configuration (through profiles), history storage, etc. The default is usually
# $HOME/.ipython. This options can also be specified through the environment
# variable IPYTHONDIR.
# c.NbConvertApp.ipython_dir = ''

# PostProcessor class used to write the  results of the conversion
# c.NbConvertApp.postprocessor_class = ''

# Whether to overwrite existing config files when copying
# c.NbConvertApp.overwrite = False

# The date format used by logging formatters for %(asctime)s
# c.NbConvertApp.log_datefmt = '%Y-%m-%d %H:%M:%S'

# Writer class used to write the  results of the conversion
# c.NbConvertApp.writer_class = 'FilesWriter'

# Path to an extra config file to load.
# 
# If specified, load this config file in addition to any other IPython config.
# c.NbConvertApp.extra_config_file = ''

# The IPython profile to use.
# c.NbConvertApp.profile = 'default'

# The export format to be used.
# c.NbConvertApp.export_format = 'html'

# overwrite base name use for output files. can only  be use when converting one
# notebook at a time.
# c.NbConvertApp.output_base = ''

# Set the log level by value or name.
# c.NbConvertApp.log_level = 30

# The Logging format template
# c.NbConvertApp.log_format = '[%(name)s]%(highlevel)s %(message)s'

# List of notebooks to convert. Wildcards are supported. Filenames passed
# positionally will be added to the list.
# c.NbConvertApp.notebooks = []

# Whether to install the default config files into the profile dir. If a new
# profile is being created, and IPython contains config files for that profile,
# then they will be staged into the new directory.  Otherwise, default config
# files will be automatically generated.
# c.NbConvertApp.copy_config_files = False

#------------------------------------------------------------------------------
# NbConvertBase configuration
#------------------------------------------------------------------------------

# Global configurable class for shared config
# 
# Useful for display data priority that might be use by many transformers

# default highlight language
# c.NbConvertBase.default_language = 'ipython'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.NbConvertBase.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

#------------------------------------------------------------------------------
# ProfileDir configuration
#------------------------------------------------------------------------------

# An object to manage the profile directory and its resources.
# 
# The profile directory is used by all IPython applications, to manage
# configuration, logging and security.
# 
# This object knows how to find, create and manage these directories. This
# should be used by any code that wants to handle profiles.

# Set the profile location directly. This overrides the logic used by the
# `profile` option.
# c.ProfileDir.location = ''

#------------------------------------------------------------------------------
# Exporter configuration
#------------------------------------------------------------------------------

# Class containing methods that sequentially run a list of preprocessors on a
# NotebookNode object and then return the modified NotebookNode object and
# accompanying resources dict.

# List of preprocessors, by name or namespace, to enable.
# c.Exporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.Exporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# Extension of the file that should be written to disk
# c.Exporter.file_extension = 'txt'

#------------------------------------------------------------------------------
# HTMLExporter configuration
#------------------------------------------------------------------------------

# Exports a basic HTML document.  This exporter assists with the export of HTML.
# Inherit from it if you are writing your own HTML template and need custom
# preprocessors/filters.  If you don't need custom preprocessors/ filters, just
# change the 'template_file' config option.

# HTMLExporter will inherit config from: TemplateExporter, Exporter

# formats of raw cells to be included in this Exporter's output.
# c.HTMLExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.HTMLExporter.filters = {}

# 
# c.HTMLExporter.template_extension = '.tpl'

# 
# c.HTMLExporter.jinja_logic_block_end = ''

# 
# c.HTMLExporter.template_path = ['.']

# 
# c.HTMLExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.HTMLExporter.file_extension = 'txt'

# 
# c.HTMLExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.HTMLExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.HTMLExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.HTMLExporter.jinja_comment_block_end = ''

# 
# c.HTMLExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.HTMLExporter.template_file = 'default'

# 
# c.HTMLExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# LatexExporter configuration
#------------------------------------------------------------------------------

# Exports to a Latex template.  Inherit from this class if your template is
# LaTeX based and you need custom tranformers/filters.  Inherit from it if  you
# are writing your own HTML template and need custom tranformers/filters.   If
# you don't need custom tranformers/filters, just change the  'template_file'
# config option.  Place your template in the special "/latex"  subfolder of the
# "../templates" folder.

# LatexExporter will inherit config from: TemplateExporter, Exporter

# formats of raw cells to be included in this Exporter's output.
# c.LatexExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.LatexExporter.filters = {}

# 
# c.LatexExporter.template_extension = '.tplx'

# 
# c.LatexExporter.jinja_logic_block_end = '*))'

# 
# c.LatexExporter.template_path = ['.']

# 
# c.LatexExporter.jinja_variable_block_start = '((('

# Extension of the file that should be written to disk
# c.LatexExporter.file_extension = 'txt'

# 
# c.LatexExporter.jinja_logic_block_start = '((*'

# List of preprocessors, by name or namespace, to enable.
# c.LatexExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.LatexExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.LatexExporter.jinja_comment_block_end = '=))'

# 
# c.LatexExporter.jinja_comment_block_start = '((='

# Name of the template file to use
# c.LatexExporter.template_file = 'default'

# 
# c.LatexExporter.jinja_variable_block_end = ')))'

#------------------------------------------------------------------------------
# MarkdownExporter configuration
#------------------------------------------------------------------------------

# Exports to a markdown document (.md)

# MarkdownExporter will inherit config from: TemplateExporter, Exporter

# formats of raw cells to be included in this Exporter's output.
# c.MarkdownExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.MarkdownExporter.filters = {}

# 
# c.MarkdownExporter.template_extension = '.tpl'

# 
# c.MarkdownExporter.jinja_logic_block_end = ''

# 
# c.MarkdownExporter.template_path = ['.']

# 
# c.MarkdownExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.MarkdownExporter.file_extension = 'txt'

# 
# c.MarkdownExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.MarkdownExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.MarkdownExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.MarkdownExporter.jinja_comment_block_end = ''

# 
# c.MarkdownExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.MarkdownExporter.template_file = 'default'

# 
# c.MarkdownExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# PythonExporter configuration
#------------------------------------------------------------------------------

# Exports a Python code file.

# PythonExporter will inherit config from: TemplateExporter, Exporter

# formats of raw cells to be included in this Exporter's output.
# c.PythonExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.PythonExporter.filters = {}

# 
# c.PythonExporter.template_extension = '.tpl'

# 
# c.PythonExporter.jinja_logic_block_end = ''

# 
# c.PythonExporter.template_path = ['.']

# 
# c.PythonExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.PythonExporter.file_extension = 'txt'

# 
# c.PythonExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.PythonExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.PythonExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.PythonExporter.jinja_comment_block_end = ''

# 
# c.PythonExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.PythonExporter.template_file = 'default'

# 
# c.PythonExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# RSTExporter configuration
#------------------------------------------------------------------------------

# Exports restructured text documents.

# RSTExporter will inherit config from: TemplateExporter, Exporter

# formats of raw cells to be included in this Exporter's output.
# c.RSTExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.RSTExporter.filters = {}

# 
# c.RSTExporter.template_extension = '.tpl'

# 
# c.RSTExporter.jinja_logic_block_end = ''

# 
# c.RSTExporter.template_path = ['.']

# 
# c.RSTExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.RSTExporter.file_extension = 'txt'

# 
# c.RSTExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.RSTExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.RSTExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.RSTExporter.jinja_comment_block_end = ''

# 
# c.RSTExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.RSTExporter.template_file = 'default'

# 
# c.RSTExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# SlidesExporter configuration
#------------------------------------------------------------------------------

# Exports HTML slides with reveal.js

# SlidesExporter will inherit config from: HTMLExporter, TemplateExporter,
# Exporter

# formats of raw cells to be included in this Exporter's output.
# c.SlidesExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.SlidesExporter.filters = {}

# 
# c.SlidesExporter.template_extension = '.tpl'

# 
# c.SlidesExporter.jinja_logic_block_end = ''

# 
# c.SlidesExporter.template_path = ['.']

# 
# c.SlidesExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.SlidesExporter.file_extension = 'txt'

# 
# c.SlidesExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.SlidesExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.SlidesExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.SlidesExporter.jinja_comment_block_end = ''

# 
# c.SlidesExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.SlidesExporter.template_file = 'default'

# 
# c.SlidesExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# TemplateExporter configuration
#------------------------------------------------------------------------------

# Exports notebooks into other file formats.  Uses Jinja 2 templating engine to
# output new formats.  Inherit from this class if you are creating a new
# template type along with new filters/preprocessors.  If the filters/
# preprocessors provided by default suffice, there is no need to inherit from
# this class.  Instead, override the template_file and file_extension traits via
# a config file.
# 
# - highlight2latex - get_lines - comment_lines - citation2latex -
# ipython2python - strip_files_prefix - markdown2html - ansi2latex -
# escape_latex - html2text - path2url - filter_data_type - strip_ansi -
# add_prompts - posix_path - highlight2html - markdown2latex - wrap_text -
# indent - strip_dollars - add_anchor - ansi2html - ascii_only - markdown2rst

# TemplateExporter will inherit config from: Exporter

# formats of raw cells to be included in this Exporter's output.
# c.TemplateExporter.raw_mimetypes = []

# Dictionary of filters, by name and namespace, to add to the Jinja environment.
# c.TemplateExporter.filters = {}

# 
# c.TemplateExporter.template_extension = '.tpl'

# 
# c.TemplateExporter.jinja_logic_block_end = ''

# 
# c.TemplateExporter.template_path = ['.']

# 
# c.TemplateExporter.jinja_variable_block_start = ''

# Extension of the file that should be written to disk
# c.TemplateExporter.file_extension = 'txt'

# 
# c.TemplateExporter.jinja_logic_block_start = ''

# List of preprocessors, by name or namespace, to enable.
# c.TemplateExporter.preprocessors = []

# List of preprocessors available by default, by name, namespace,  instance, or
# type.
# c.TemplateExporter.default_preprocessors = ['IPython.nbconvert.preprocessors.coalesce_streams', 'IPython.nbconvert.preprocessors.SVG2PDFPreprocessor', 'IPython.nbconvert.preprocessors.ExtractOutputPreprocessor', 'IPython.nbconvert.preprocessors.CSSHTMLHeaderPreprocessor', 'IPython.nbconvert.preprocessors.RevealHelpPreprocessor', 'IPython.nbconvert.preprocessors.LatexPreprocessor', 'IPython.nbconvert.preprocessors.HighlightMagicsPreprocessor']

# 
# c.TemplateExporter.jinja_comment_block_end = ''

# 
# c.TemplateExporter.jinja_comment_block_start = ''

# Name of the template file to use
# c.TemplateExporter.template_file = 'default'

# 
# c.TemplateExporter.jinja_variable_block_end = ''

#------------------------------------------------------------------------------
# CSSHTMLHeaderPreprocessor configuration
#------------------------------------------------------------------------------

# Preprocessor used to pre-process notebook for HTML output.  Adds IPython
# notebook front-end CSS and Pygments CSS to HTML output.

# CSSHTMLHeaderPreprocessor will inherit config from: Preprocessor,
# NbConvertBase

# default highlight language
# c.CSSHTMLHeaderPreprocessor.default_language = 'ipython'

# CSS highlight class identifier
# c.CSSHTMLHeaderPreprocessor.highlight_class = '.highlight'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.CSSHTMLHeaderPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.CSSHTMLHeaderPreprocessor.enabled = False

#------------------------------------------------------------------------------
# ConvertFiguresPreprocessor configuration
#------------------------------------------------------------------------------

# Converts all of the outputs in a notebook from one format to another.

# ConvertFiguresPreprocessor will inherit config from: Preprocessor,
# NbConvertBase

# default highlight language
# c.ConvertFiguresPreprocessor.default_language = 'ipython'

# Format the converter writes
# c.ConvertFiguresPreprocessor.to_format = ''

# Format the converter accepts
# c.ConvertFiguresPreprocessor.from_format = ''

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.ConvertFiguresPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.ConvertFiguresPreprocessor.enabled = False

#------------------------------------------------------------------------------
# ExtractOutputPreprocessor configuration
#------------------------------------------------------------------------------

# Extracts all of the outputs from the notebook file.  The extracted  outputs
# are returned in the 'resources' dictionary.

# ExtractOutputPreprocessor will inherit config from: Preprocessor,
# NbConvertBase

# default highlight language
# c.ExtractOutputPreprocessor.default_language = 'ipython'

# 
# c.ExtractOutputPreprocessor.extract_output_types = {'jpeg', 'application/pdf', 'svg', 'png'}

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.ExtractOutputPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.ExtractOutputPreprocessor.output_filename_template = '{unique_key}_{cell_index}_{index}{extension}'

# 
# c.ExtractOutputPreprocessor.enabled = False

#------------------------------------------------------------------------------
# HighlightMagicsPreprocessor configuration
#------------------------------------------------------------------------------

# Detects and tags code cells that use a different languages than Python.

# HighlightMagicsPreprocessor will inherit config from: Preprocessor,
# NbConvertBase

# default highlight language
# c.HighlightMagicsPreprocessor.default_language = 'ipython'

# Syntax highlighting for magic's extension languages. Each item associates a
# language magic extension such as %%R, with a pygments lexer such as r.
# c.HighlightMagicsPreprocessor.languages = {}

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.HighlightMagicsPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.HighlightMagicsPreprocessor.enabled = False

#------------------------------------------------------------------------------
# LatexPreprocessor configuration
#------------------------------------------------------------------------------

# Preprocessor for latex destined documents.
# 
# Mainly populates the `latex` key in the resources dict, adding definitions for
# pygments highlight styles.

# LatexPreprocessor will inherit config from: Preprocessor, NbConvertBase

# default highlight language
# c.LatexPreprocessor.default_language = 'ipython'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.LatexPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.LatexPreprocessor.enabled = False

#------------------------------------------------------------------------------
# Preprocessor configuration
#------------------------------------------------------------------------------

# A configurable preprocessor
# 
# Inherit from this class if you wish to have configurability for your
# preprocessor.
# 
# Any configurable traitlets this class exposed will be configurable in profiles
# using c.SubClassName.attribute = value
# 
# you can overwrite :meth:`preprocess_cell` to apply a transformation
# independently on each cell or :meth:`preprocess` if you prefer your own logic.
# See corresponding docstring for informations.
# 
# Disabled by default and can be enabled via the config by
#     'c.YourPreprocessorName.enabled = True'

# Preprocessor will inherit config from: NbConvertBase

# default highlight language
# c.Preprocessor.default_language = 'ipython'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.Preprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.Preprocessor.enabled = False

#------------------------------------------------------------------------------
# RevealHelpPreprocessor configuration
#------------------------------------------------------------------------------

# RevealHelpPreprocessor will inherit config from: Preprocessor, NbConvertBase

# default highlight language
# c.RevealHelpPreprocessor.default_language = 'ipython'

# The URL prefix for reveal.js. This can be a a relative URL for a local copy of
# reveal.js, or point to a CDN.
# 
# For speaker notes to work, a local reveal.js prefix must be used.
# c.RevealHelpPreprocessor.url_prefix = 'reveal.js'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.RevealHelpPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# 
# c.RevealHelpPreprocessor.enabled = False

#------------------------------------------------------------------------------
# SVG2PDFPreprocessor configuration
#------------------------------------------------------------------------------

# Converts all of the outputs in a notebook from SVG to PDF.

# SVG2PDFPreprocessor will inherit config from: ConvertFiguresPreprocessor,
# Preprocessor, NbConvertBase

# Format the converter accepts
# c.SVG2PDFPreprocessor.from_format = ''

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.SVG2PDFPreprocessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# The path to Inkscape, if necessary
# c.SVG2PDFPreprocessor.inkscape = ''

# 
# c.SVG2PDFPreprocessor.enabled = False

# Format the converter writes
# c.SVG2PDFPreprocessor.to_format = ''

# default highlight language
# c.SVG2PDFPreprocessor.default_language = 'ipython'

# The command to use for converting SVG to PDF
# 
# This string is a template, which will be formatted with the keys to_filename
# and from_filename.
# 
# The conversion call must read the SVG from {from_flename}, and write a PDF to
# {to_filename}.
# c.SVG2PDFPreprocessor.command = ''

#------------------------------------------------------------------------------
# FilesWriter configuration
#------------------------------------------------------------------------------

# Consumes nbconvert output and produces files.

# FilesWriter will inherit config from: WriterBase, NbConvertBase

# Directory to write output to.  Leave blank to output to the current directory
# c.FilesWriter.build_directory = ''

# List of the files that the notebook references.  Files will be  included with
# written output.
# c.FilesWriter.files = []

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.FilesWriter.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# default highlight language
# c.FilesWriter.default_language = 'ipython'

#------------------------------------------------------------------------------
# StdoutWriter configuration
#------------------------------------------------------------------------------

# Consumes output from nbconvert export...() methods and writes to the  stdout
# stream.

# StdoutWriter will inherit config from: WriterBase, NbConvertBase

# List of the files that the notebook references.  Files will be  included with
# written output.
# c.StdoutWriter.files = []

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.StdoutWriter.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# default highlight language
# c.StdoutWriter.default_language = 'ipython'

#------------------------------------------------------------------------------
# WriterBase configuration
#------------------------------------------------------------------------------

# Consumes output from nbconvert export...() methods and writes to a useful
# location.

# WriterBase will inherit config from: NbConvertBase

# List of the files that the notebook references.  Files will be  included with
# written output.
# c.WriterBase.files = []

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.WriterBase.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# default highlight language
# c.WriterBase.default_language = 'ipython'

#------------------------------------------------------------------------------
# PDFPostProcessor configuration
#------------------------------------------------------------------------------

# Writer designed to write to PDF files

# PDFPostProcessor will inherit config from: PostProcessorBase, NbConvertBase

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.PDFPostProcessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

# Shell command used to run bibtex.
# c.PDFPostProcessor.bib_command = ['bibtex', '{filename}']

# Shell command used to compile PDF.
# c.PDFPostProcessor.latex_command = ['pdflatex', '{filename}']

# How many times pdflatex will be called.
# c.PDFPostProcessor.latex_count = 3

# Whether or not to open the pdf after the compile call.
# c.PDFPostProcessor.pdf_open = False

# default highlight language
# c.PDFPostProcessor.default_language = 'ipython'

# Filename extensions of temp files to remove after running.
# c.PDFPostProcessor.temp_file_exts = ['.aux', '.bbl', '.blg', '.idx', '.log', '.out']

# Whether or not to display the output of the compile call.
# c.PDFPostProcessor.verbose = False

#------------------------------------------------------------------------------
# PostProcessorBase configuration
#------------------------------------------------------------------------------

# PostProcessorBase will inherit config from: NbConvertBase

# default highlight language
# c.PostProcessorBase.default_language = 'ipython'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.PostProcessorBase.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']

#------------------------------------------------------------------------------
# ServePostProcessor configuration
#------------------------------------------------------------------------------

# Post processor designed to serve files
# 
# Proxies reveal.js requests to a CDN if no local reveal.js is present

# ServePostProcessor will inherit config from: PostProcessorBase, NbConvertBase

# port for the server to listen on.
# c.ServePostProcessor.port = 8000

# The IP address to listen on.
# c.ServePostProcessor.ip = '127.0.0.1'

# Should the browser be opened automatically?
# c.ServePostProcessor.open_in_browser = True

# URL prefix for reveal.js
# c.ServePostProcessor.reveal_prefix = 'reveal.js'

# default highlight language
# c.ServePostProcessor.default_language = 'ipython'

# URL for reveal.js CDN.
# c.ServePostProcessor.reveal_cdn = 'https://cdn.jsdelivr.net/reveal.js/2.5.0'

# An ordered list of preferred output type, the first encountered will usually
# be used when converting discarding the others.
# c.ServePostProcessor.display_data_priority = ['html', 'application/pdf', 'svg', 'latex', 'png', 'jpg', 'jpeg', 'text']
