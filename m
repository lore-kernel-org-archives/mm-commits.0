From: akpm@linux-foundation.org
Subject: +
 lib-replace-fsf-address-with-web-source-in-license-notices.patch added to
 -mm tree
Date: Tue, 14 Nov 2017 15:59:27 -0800
Message-ID: <5a0b835f.LdYG69IAfOoW2FIx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753767AbdKNX73 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 18:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: replace FSF address with web source in license notices
has been added to the -mm tree.  Its filename is
     lib-replace-fsf-address-with-web-source-in-license-notices.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-replace-fsf-address-with-web-source-in-license-notices.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-replace-fsf-address-with-web-source-in-license-notices.patch

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
Subject: lib: replace FSF address with web source in license notices

A few years ago the FSF moved and "59 Temple Place" is wrong.  Having this
still in our source files feels old and unmaintained.

Let's take the license statement serious and not confuse users.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>" in the lib directory.

Link: http://lkml.kernel.org/r/20171114094201.27998-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c        |    3 +--
 lib/dma-debug.c               |    3 +--
 lib/flex_array.c              |    3 +--
 lib/llist.c                   |    3 +--
 lib/mpi/generic_mpih-add1.c   |    3 +--
 lib/mpi/generic_mpih-lshift.c |    3 +--
 lib/mpi/generic_mpih-mul1.c   |    3 +--
 lib/mpi/generic_mpih-mul2.c   |    3 +--
 lib/mpi/generic_mpih-mul3.c   |    3 +--
 lib/mpi/generic_mpih-rshift.c |    3 +--
 lib/mpi/generic_mpih-sub1.c   |    3 +--
 lib/mpi/longlong.h            |    5 ++---
 lib/mpi/mpi-bit.c             |    3 +--
 lib/mpi/mpi-cmp.c             |    3 +--
 lib/mpi/mpi-inline.h          |    3 +--
 lib/mpi/mpi-internal.h        |    3 +--
 lib/mpi/mpi-pow.c             |    3 +--
 lib/mpi/mpicoder.c            |    3 +--
 lib/mpi/mpih-cmp.c            |    3 +--
 lib/mpi/mpih-div.c            |    3 +--
 lib/mpi/mpih-mul.c            |    3 +--
 lib/mpi/mpiutil.c             |    3 +--
 lib/rbtree.c                  |    3 +--
 lib/timerqueue.c              |    3 +--
 24 files changed, 25 insertions(+), 49 deletions(-)

diff -puN lib/decompress_unlzo.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/decompress_unlzo.c
@@ -22,8 +22,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * If not, see <http://www.gnu.org/licenses/>.
  *
  * Markus F.X.J. Oberhumer
  * <markus@oberhumer.com>
diff -puN lib/dma-debug.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/dma-debug.c
--- a/lib/dma-debug.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/dma-debug.c
@@ -13,8 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/sched/task_stack.h>
diff -puN lib/flex_array.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/flex_array.c
--- a/lib/flex_array.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/flex_array.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright IBM Corporation, 2009
  *
diff -puN lib/llist.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/llist.c
--- a/lib/llist.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/llist.c
@@ -19,8 +19,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
diff -puN lib/mpi/generic_mpih-add1.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-add1.c
--- a/lib/mpi/generic_mpih-add1.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-add1.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-lshift.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-lshift.c
--- a/lib/mpi/generic_mpih-lshift.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-lshift.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-mul1.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-mul1.c
--- a/lib/mpi/generic_mpih-mul1.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-mul1.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-mul2.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-mul2.c
--- a/lib/mpi/generic_mpih-mul2.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-mul2.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-mul3.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-mul3.c
--- a/lib/mpi/generic_mpih-mul3.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-mul3.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-rshift.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-rshift.c
--- a/lib/mpi/generic_mpih-rshift.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-rshift.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/generic_mpih-sub1.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/generic_mpih-sub1.c
--- a/lib/mpi/generic_mpih-sub1.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/generic_mpih-sub1.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/longlong.h~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/longlong.h
--- a/lib/mpi/longlong.h~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/longlong.h
@@ -15,9 +15,8 @@
  * License for more details.
  *
  * You should have received a copy of the GNU Library General Public License
- * along with this file; see the file COPYING.LIB.  If not, write to
- * the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
- * MA 02111-1307, USA. */
+ * along with this file.  If not, see <http://www.gnu.org/licenses/>.
+ */
 
 #include <linux/count_zeros.h>
 
diff -puN lib/mpi/mpi-bit.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpi-bit.c
--- a/lib/mpi/mpi-bit.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpi-bit.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "mpi-internal.h"
diff -puN lib/mpi/mpi-cmp.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpi-cmp.c
--- a/lib/mpi/mpi-cmp.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpi-cmp.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "mpi-internal.h"
diff -puN lib/mpi/mpicoder.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpicoder.c
--- a/lib/mpi/mpicoder.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpicoder.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/bitops.h>
diff -puN lib/mpi/mpih-cmp.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpih-cmp.c
--- a/lib/mpi/mpih-cmp.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpih-cmp.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpih-div.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpih-div.c
--- a/lib/mpi/mpih-div.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpih-div.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpih-mul.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpih-mul.c
--- a/lib/mpi/mpih-mul.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpih-mul.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpi-inline.h~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpi-inline.h
--- a/lib/mpi/mpi-inline.h~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpi-inline.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpi-internal.h~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpi-internal.h
--- a/lib/mpi/mpi-internal.h~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpi-internal.h
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpi-pow.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpi-pow.c
--- a/lib/mpi/mpi-pow.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpi-pow.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Note: This code is heavily based on the GNU MP Library.
  *	 Actually it's the same code with only minor changes in the
diff -puN lib/mpi/mpiutil.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/mpi/mpiutil.c
--- a/lib/mpi/mpiutil.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/mpi/mpiutil.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include "mpi-internal.h"
diff -puN lib/rbtree.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/rbtree.c
--- a/lib/rbtree.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/rbtree.c
@@ -15,8 +15,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
   linux/lib/rbtree.c
 */
diff -puN lib/timerqueue.c~lib-replace-fsf-address-with-web-source-in-license-notices lib/timerqueue.c
--- a/lib/timerqueue.c~lib-replace-fsf-address-with-web-source-in-license-notices
+++ a/lib/timerqueue.c
@@ -18,8 +18,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/bug.h>
_

Patches currently in -mm which might be from martink@posteo.de are

samples-replace-fsf-address-with-web-source-in-license-notices.patch
scripts-replace-fsf-address-with-web-source-in-license-notices.patch
kernel-replace-fsf-address-with-web-source-in-license-notices.patch
init-replace-fsf-address-with-web-source-in-license-notices.patch
lib-replace-fsf-address-with-web-source-in-license-notices.patch

