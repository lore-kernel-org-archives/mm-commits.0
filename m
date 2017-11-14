From: akpm@linux-foundation.org
Subject: +
 samples-replace-fsf-address-with-web-source-in-license-notices.patch added
 to -mm tree
Date: Tue, 14 Nov 2017 15:57:14 -0800
Message-ID: <5a0b82da.ADsPLNh2VKgMAA1e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdKNX5P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 18:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples: replace FSF address with web source in license notices
has been added to the -mm tree.  Its filename is
     samples-replace-fsf-address-with-web-source-in-license-notices.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-replace-fsf-address-with-web-source-in-license-notices.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-replace-fsf-address-with-web-source-in-license-notices.patch

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

samples-replace-fsf-address-with-web-source-in-license-notices.patch
scripts-replace-fsf-address-with-web-source-in-license-notices.patch

