From: akpm@linux-foundation.org
Subject: + timerfd-v3-un-break-config_timerfd.patch added to -mm tree
Date: Tue, 27 Nov 2007 01:05:01 -0800
Message-ID: <200711270905.lAR951bH003883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbXK0JFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 04:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     timerfd: un-break CONFIG_TIMERFD
has been added to the -mm tree.  Its filename is
     timerfd-v3-un-break-config_timerfd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timerfd: un-break CONFIG_TIMERFD
From: Davide Libenzi <davidel@xmailserver.org>

Remove the broken status to CONFIG_TIMERFD.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/Kconfig~timerfd-v3-un-break-config_timerfd init/Kconfig
--- a/init/Kconfig~timerfd-v3-un-break-config_timerfd
+++ a/init/Kconfig
@@ -566,7 +566,6 @@ config SIGNALFD
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	select ANON_INODES
-	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
_

Patches currently in -mm which might be from davidel@xmailserver.org are

timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-kvm.patch
use-wake_up_locked-in-eventpoll.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
