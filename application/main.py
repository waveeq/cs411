import flask, flask.views
import os


class Main(flask.views.MethodView):
    # page paramter allows us to load other html pages
    # that don't have python views created.
    def get(self, page="index"):
        page += ".html"

        if os.path.isfile('templates/' + page):
            return flask.render_template(page)
        else:
            flask.abort(404)