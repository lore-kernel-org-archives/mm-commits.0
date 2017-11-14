From: akpm@linux-foundation.org
Subject: +
 scripts-replace-fsf-address-with-web-source-in-license-notices.patch added
 to -mm tree
Date: Tue, 14 Nov 2017 15:57:17 -0800
Message-ID: <5a0b82dd.lxtbCCM/zKh/Hc8h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbdKNX5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 18:57:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: replace FSF address with web source in license notices
has been added to the -mm tree.  Its filename is
     scripts-replace-fsf-address-with-web-source-in-license-notices.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-replace-fsf-address-with-web-source-in-license-notices.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-replace-fsf-address-with-web-source-in-license-notices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: scripts: replace FSF address with web source in license notices

A few years ago the FSF moved and "59 Temple Place" is wrong.  Having this
still in our source files feels old and unmaintained.

Let's take the license statement serious and not confuse users.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>" in the scripts
directory.

Link: http://lkml.kernel.org/r/20171114100646.29301-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/dtc/checks.c                |    4 +---
 scripts/dtc/data.c                  |    4 +---
 scripts/dtc/dtc-lexer.l             |    4 +---
 scripts/dtc/dtc-lexer.lex.c_shipped |    4 +---
 scripts/dtc/dtc-parser.y            |    4 +---
 scripts/dtc/dtc.c                   |    4 +---
 scripts/dtc/fdtget.c                |    4 +---
 scripts/dtc/fdtput.c                |    4 +---
 scripts/dtc/flattree.c              |    4 +---
 scripts/dtc/fstree.c                |    4 +---
 scripts/dtc/livetree.c              |    4 +---
 scripts/dtc/srcpos.c                |    4 +---
 scripts/dtc/srcpos.h                |    4 +---
 scripts/dtc/treesource.c            |    4 +---
 scripts/dtc/util.c                  |    4 +---
 scripts/dtc/util.h                  |    4 +---
 scripts/genksyms/genksyms.c         |    4 ++--
 scripts/genksyms/genksyms.h         |    4 ++--
 scripts/genksyms/lex.l              |    4 ++--
 scripts/genksyms/lex.lex.c_shipped  |    4 ++--
 scripts/genksyms/parse.y            |    4 ++--
 scripts/selinux/mdp/mdp.c           |    3 +--
 22 files changed, 27 insertions(+), 60 deletions(-)

diff -puN scripts/dtc/checks.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/checks.c
--- a/scripts/dtc/checks.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/checks.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/data.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/data.c
--- a/scripts/dtc/data.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/data.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/dtc.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/dtc.c
--- a/scripts/dtc/dtc.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/dtc.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <sys/stat.h>
diff -puN scripts/dtc/dtc-lexer.l~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/dtc-lexer.l
--- a/scripts/dtc/dtc-lexer.l~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/dtc-lexer.l
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 %option noyywrap nounput noinput never-interactive
diff -puN scripts/dtc/dtc-lexer.lex.c_shipped~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/dtc-lexer.lex.c_shipped
--- a/scripts/dtc/dtc-lexer.lex.c_shipped~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/dtc-lexer.lex.c_shipped
@@ -618,9 +618,7 @@ char *yytext;
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #define YY_NO_INPUT 1
 
diff -puN scripts/dtc/dtc-parser.y~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/dtc-parser.y
--- a/scripts/dtc/dtc-parser.y~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/dtc-parser.y
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 %{
 #include <stdio.h>
diff -puN scripts/dtc/fdtget.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/fdtget.c
--- a/scripts/dtc/fdtget.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/fdtget.c
@@ -18,9 +18,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
- * MA 02111-1307 USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <assert.h>
diff -puN scripts/dtc/fdtput.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/fdtput.c
--- a/scripts/dtc/fdtput.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/fdtput.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
- * MA 02111-1307 USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <assert.h>
diff -puN scripts/dtc/flattree.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/flattree.c
--- a/scripts/dtc/flattree.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/flattree.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/fstree.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/fstree.c
--- a/scripts/dtc/fstree.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/fstree.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/livetree.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/livetree.c
--- a/scripts/dtc/livetree.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/livetree.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/srcpos.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/srcpos.c
--- a/scripts/dtc/srcpos.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/srcpos.c
@@ -12,9 +12,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #define _GNU_SOURCE
diff -puN scripts/dtc/srcpos.h~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/srcpos.h
--- a/scripts/dtc/srcpos.h~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/srcpos.h
@@ -12,9 +12,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _SRCPOS_H_
diff -puN scripts/dtc/treesource.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/treesource.c
--- a/scripts/dtc/treesource.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/treesource.c
@@ -13,9 +13,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "dtc.h"
diff -puN scripts/dtc/util.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/util.c
--- a/scripts/dtc/util.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/util.c
@@ -16,9 +16,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <ctype.h>
diff -puN scripts/dtc/util.h~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/dtc/util.h
--- a/scripts/dtc/util.h~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/dtc/util.h
@@ -20,9 +20,7 @@
  *  General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- *                                                                   USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifdef __GNUC__
diff -puN scripts/genksyms/genksyms.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/genksyms/genksyms.c
--- a/scripts/genksyms/genksyms.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/genksyms/genksyms.c
@@ -18,8 +18,8 @@
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 #include <stdio.h>
 #include <string.h>
diff -puN scripts/genksyms/genksyms.h~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/genksyms/genksyms.h
--- a/scripts/genksyms/genksyms.h~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/genksyms/genksyms.h
@@ -17,8 +17,8 @@
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 #ifndef MODUTILS_GENKSYMS_H
 #define MODUTILS_GENKSYMS_H 1
diff -puN scripts/genksyms/lex.l~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/genksyms/lex.l
--- a/scripts/genksyms/lex.l~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/genksyms/lex.l
@@ -17,8 +17,8 @@
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 
 %{
diff -puN scripts/genksyms/lex.lex.c_shipped~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/genksyms/lex.lex.c_shipped
--- a/scripts/genksyms/lex.lex.c_shipped~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/genksyms/lex.lex.c_shipped
@@ -555,8 +555,8 @@ char *yytext;
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 #include <limits.h>
 #include <stdlib.h>
diff -puN scripts/genksyms/parse.y~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/genksyms/parse.y
--- a/scripts/genksyms/parse.y~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/genksyms/parse.y
@@ -17,8 +17,8 @@
    General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 
 %{
diff -puN scripts/selinux/mdp/mdp.c~scripts-replace-fsf-address-with-web-source-in-license-notices scripts/selinux/mdp/mdp.c
--- a/scripts/selinux/mdp/mdp.c~scripts-replace-fsf-address-with-web-source-in-license-notices
+++ a/scripts/selinux/mdp/mdp.c
@@ -16,8 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) IBM Corporation, 2006
  *
_

Patches currently in -mm which might be from martink@posteo.de are

samples-replace-fsf-address-with-web-source-in-license-notices.patch
scripts-replace-fsf-address-with-web-source-in-license-notices.patch

