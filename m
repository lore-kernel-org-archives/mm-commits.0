From: akpm@linux-foundation.org
Subject: [merged] timers-add-missing-kernel-doc.patch removed from -mm tree
Date: Fri, 10 Apr 2009 13:09:24 -0700
Message-ID: <200904102009.n3AK9OZW029845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516AbZDJUNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 16:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johannes@sipsolutions.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timers: add missing kernel-doc
has been removed from the -mm tree.  Its filename was
     timers-add-missing-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timers: add missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc parameter notation and change function name to its
new name:

Warning(kernel/timer.c:543): No description found for parameter 'name'
Warning(kernel/timer.c:543): No description found for parameter 'key'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timers-add-missing-kernel-doc kernel/timer.c
--- a/kernel/timer.c~timers-add-missing-kernel-doc
+++ a/kernel/timer.c
@@ -531,10 +531,13 @@ static void __init_timer(struct timer_li
 }
 
 /**
- * init_timer - initialize a timer.
+ * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
+ * @name: name of the timer
+ * @key: lockdep class key of the fake lock used for tracking timer
+ *       sync lock dependencies
  *
- * init_timer() must be done to a timer prior calling *any* of the
+ * init_timer_key() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
 void init_timer_key(struct timer_list *timer,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-fix-email-address.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
filemap-fix-kernel-doc-warnings.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
shmem-respect-max_lfs_filesize-fix.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

