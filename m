From: akpm@linux-foundation.org
Subject: [alternative-merged]
 samples-replace-fsf-address-with-web-source-in-license-notices.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 10:52:29 -0800
Message-ID: <20171115185229.IsocFjxUv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdKOSwb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 13:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: greg@kroah.com, martink@posteo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: samples: replace FSF address with web source in license notices
has been removed from the -mm tree.  Its filename was
     samples-replace-fsf-address-with-web-source-in-license-notices.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: samples: replace FSF address with web source in license notices

A few years ago the FSF moved and "59 Temple Place" is wrong.  Having this
still in our source files feels old and unmaintained.

Let's take the license statement serious and not confuse users.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>" in the samples
directory.

Link: http://lkml.kernel.org/r/20171114095037.28563-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/auxdisplay/cfag12864b-example.c |    3 +--
 samples/configfs/configfs_sample.c      |    6 ++----
 samples/connector/cn_test.c             |    3 +--
 samples/connector/ucon.c                |    3 +--
 samples/hw_breakpoint/data_breakpoint.c |    3 +--
 5 files changed, 6 insertions(+), 12 deletions(-)

diff -puN samples/auxdisplay/cfag12864b-example.c~samples-replace-fsf-address-with-web-source-in-license-notices samples/auxdisplay/cfag12864b-example.c
--- a/samples/auxdisplay/cfag12864b-example.c~samples-replace-fsf-address-with-web-source-in-license-notices
+++ a/samples/auxdisplay/cfag12864b-example.c
@@ -17,8 +17,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff -puN samples/configfs/configfs_sample.c~samples-replace-fsf-address-with-web-source-in-license-notices samples/configfs/configfs_sample.c
--- a/samples/configfs/configfs_sample.c~samples-replace-fsf-address-with-web-source-in-license-notices
+++ a/samples/configfs/configfs_sample.c
@@ -15,10 +15,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Based on sysfs:
  * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
diff -puN samples/connector/cn_test.c~samples-replace-fsf-address-with-web-source-in-license-notices samples/connector/cn_test.c
--- a/samples/connector/cn_test.c~samples-replace-fsf-address-with-web-source-in-license-notices
+++ a/samples/connector/cn_test.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "cn_test: " fmt
diff -puN samples/connector/ucon.c~samples-replace-fsf-address-with-web-source-in-license-notices samples/connector/ucon.c
--- a/samples/connector/ucon.c~samples-replace-fsf-address-with-web-source-in-license-notices
+++ a/samples/connector/ucon.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <asm/types.h>
diff -puN samples/hw_breakpoint/data_breakpoint.c~samples-replace-fsf-address-with-web-source-in-license-notices samples/hw_breakpoint/data_breakpoint.c
--- a/samples/hw_breakpoint/data_breakpoint.c~samples-replace-fsf-address-with-web-source-in-license-notices
+++ a/samples/hw_breakpoint/data_breakpoint.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * usage: insmod data_breakpoint.ko ksym=<ksym_name>
  *
_

Patches currently in -mm which might be from martink@posteo.de are

scripts-replace-fsf-address-with-web-source-in-license-notices.patch
kernel-replace-fsf-address-with-web-source-in-license-notices.patch
init-replace-fsf-address-with-web-source-in-license-notices.patch
lib-replace-fsf-address-with-web-source-in-license-notices.patch

