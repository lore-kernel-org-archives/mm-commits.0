From: akpm@linux-foundation.org
Subject: [alternative-merged]
 kernel-replace-fsf-address-with-web-source-in-license-notices.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 10:52:38 -0800
Message-ID: <20171115185238.Kmcjg6WTK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdKOSwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 13:52:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: replace FSF address with web source in license notices
has been removed from the -mm tree.  Its filename was
     kernel-replace-fsf-address-with-web-source-in-license-notices.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: kernel: replace FSF address with web source in license notices

A few years ago the FSF moved and "59 Temple Place" is wrong.  Having this
still in our source files feels old and unmaintained.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>".

Link: http://lkml.kernel.org/r/20171114091008.26555-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c                      |    3 +--
 kernel/audit.h                      |    3 +--
 kernel/audit_watch.c                |    3 +--
 kernel/auditfilter.c                |    3 +--
 kernel/auditsc.c                    |    3 +--
 kernel/events/hw_breakpoint.c       |    3 +--
 kernel/events/uprobes.c             |    3 +--
 kernel/extable.c                    |    3 +--
 kernel/futex.c                      |    3 +--
 kernel/kprobes.c                    |    3 +--
 kernel/module.c                     |    3 +--
 kernel/params.c                     |    3 +--
 kernel/time/timeconv.c              |    3 +--
 kernel/trace/trace_events_filter.c  |    3 +--
 kernel/trace/trace_events_trigger.c |    3 +--
 kernel/trace/trace_kprobe.c         |    3 +--
 kernel/trace/trace_probe.c          |    3 +--
 kernel/trace/trace_probe.h          |    3 +--
 kernel/trace/trace_uprobe.c         |    3 +--
 kernel/tracepoint.c                 |    3 +--
 20 files changed, 20 insertions(+), 40 deletions(-)

diff -puN kernel/audit.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/audit.c
--- a/kernel/audit.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/audit.c
@@ -16,8 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Written by Rickard E. (Rik) Faith <faith@redhat.com>
  *
diff -puN kernel/auditfilter.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/auditfilter.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff -puN kernel/audit.h~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/audit.h
--- a/kernel/audit.h~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/audit.h
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/fs.h>
diff -puN kernel/auditsc.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/auditsc.c
--- a/kernel/auditsc.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/auditsc.c
@@ -17,8 +17,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Written by Rickard E. (Rik) Faith <faith@redhat.com>
  *
diff -puN kernel/audit_watch.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/audit_watch.c
--- a/kernel/audit_watch.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/audit_watch.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/file.h>
diff -puN kernel/events/hw_breakpoint.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/events/hw_breakpoint.c
--- a/kernel/events/hw_breakpoint.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/events/hw_breakpoint.c
@@ -10,8 +10,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) IBM Corporation, 2009
diff -puN kernel/events/uprobes.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/events/uprobes.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) IBM Corporation, 2008-2012
  * Authors:
diff -puN kernel/extable.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/extable.c
--- a/kernel/extable.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/extable.c
@@ -12,8 +12,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
 #include <linux/ftrace.h>
 #include <linux/memory.h>
diff -puN kernel/futex.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/futex.c
--- a/kernel/futex.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/futex.c
@@ -41,8 +41,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/slab.h>
 #include <linux/poll.h>
diff -puN kernel/kprobes.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/kprobes.c
--- a/kernel/kprobes.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/kprobes.c
@@ -13,8 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) IBM Corporation, 2002, 2004
  *
diff -puN kernel/module.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/module.c
--- a/kernel/module.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/module.c
@@ -13,8 +13,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
 #include <linux/export.h>
 #include <linux/extable.h>
diff -puN kernel/params.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/params.c
--- a/kernel/params.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/params.c
@@ -12,8 +12,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN kernel/time/timeconv.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/time/timeconv.c
--- a/kernel/time/timeconv.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/time/timeconv.c
@@ -15,8 +15,7 @@
  *
  * You should have received a copy of the GNU Library General Public
  * License along with the GNU C Library; see the file COPYING.LIB.  If not,
- * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 02111-1307, USA.
+ * see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff -puN kernel/tracepoint.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/tracepoint.c
--- a/kernel/tracepoint.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/tracepoint.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/module.h>
 #include <linux/mutex.h>
diff -puN kernel/trace/trace_events_filter.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_events_filter.c
--- a/kernel/trace/trace_events_filter.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_events_filter.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
diff -puN kernel/trace/trace_events_trigger.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_events_trigger.c
--- a/kernel/trace/trace_events_trigger.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_events_trigger.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) 2013 Tom Zanussi <tom.zanussi@linux.intel.com>
  */
diff -puN kernel/trace/trace_kprobe.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_kprobe.c
--- a/kernel/trace/trace_kprobe.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_kprobe.c
@@ -13,8 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 #define pr_fmt(fmt)	"trace_kprobe: " fmt
 
diff -puN kernel/trace/trace_probe.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_probe.c
--- a/kernel/trace/trace_probe.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_probe.c
@@ -11,8 +11,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * This code was copied from kernel/trace/trace_kprobe.c written by
  * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
diff -puN kernel/trace/trace_probe.h~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_probe.h
--- a/kernel/trace/trace_probe.h~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_probe.h
@@ -11,8 +11,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * This code was copied from kernel/trace/trace_kprobe.h written by
  * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
diff -puN kernel/trace/trace_uprobe.c~kernel-replace-fsf-address-with-web-source-in-license-notices kernel/trace/trace_uprobe.c
--- a/kernel/trace/trace_uprobe.c~kernel-replace-fsf-address-with-web-source-in-license-notices
+++ a/kernel/trace/trace_uprobe.c
@@ -11,8 +11,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  *
  * Copyright (C) IBM Corporation, 2010-2012
  * Author:	Srikar Dronamraju <srikar@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from martink@posteo.de are

init-replace-fsf-address-with-web-source-in-license-notices.patch
lib-replace-fsf-address-with-web-source-in-license-notices.patch

