From: akpm@linux-foundation.org
Subject: - pm3fb-preliminary-24-to-26-port-fix.patch removed from -mm tree
Date: Thu, 10 May 2007 22:05:58 -0700
Message-ID: <200705110505.l4B55wIF006586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471AbXEKFGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 01:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@gmail.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     pm3fb-preliminary-24-to-26-port-fix
has been removed from the -mm tree.  Its filename was
     pm3fb-preliminary-24-to-26-port-fix.patch

This patch was dropped because it was folded into pm3fb-preliminary-24-to-26-port.patch

------------------------------------------------------
Subject: pm3fb-preliminary-24-to-26-port-fix
From: Andrew Morton <akpm@linux-foundation.org>

Nuke pestiferous CVS string.

Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/pm3fb.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/video/pm3fb.h~pm3fb-preliminary-24-to-26-port-fix include/video/pm3fb.h
--- a/include/video/pm3fb.h~pm3fb-preliminary-24-to-26-port-fix
+++ a/include/video/pm3fb.h
@@ -7,9 +7,6 @@
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive for
  *  more details.
- *
- *  $Header: /cvsroot/linux/drivers/video/pm3fb.h,v 1.1 2002/02/25 19:11:06 marcelo Exp $
- *
  */
 
 #ifndef PM3FB_H
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
pm3fb-preliminary-24-to-26-port.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
