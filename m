From: akpm@linux-foundation.org
Subject: [merged] ppsh-needs-linux-typesh.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:24 -0700
Message-ID: <200907302037.n6UKbOsm011345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbZG3Uhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps.h needs <linux/types.h>
has been removed from the -mm tree.  Its filename was
     ppsh-needs-linux-typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps.h needs <linux/types.h>
From: Dave Jones <davej@redhat.com>

Found with make headers_check

/usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pps.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pps.h~ppsh-needs-linux-typesh include/linux/pps.h
--- a/include/linux/pps.h~ppsh-needs-linux-typesh
+++ a/include/linux/pps.h
@@ -22,6 +22,8 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
+#include <linux/types.h>
+
 #define PPS_VERSION		"5.3.6"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch

