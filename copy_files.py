# copy index to templates and other to static folder
import pathlib
import shutil

flutter_web_build_path = pathlib.Path('flutterui/build/web')
static_dir_path = pathlib.Path('static')

shutil.copytree(flutter_web_build_path, static_dir_path, dirs_exist_ok=True)
shutil.move(static_dir_path / 'index.html', 'webui/templates/index.html')
