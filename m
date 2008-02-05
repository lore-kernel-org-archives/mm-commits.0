From: akpm@linux-foundation.org
Subject: - timerfd-v3-un-break-config_timerfd.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:46 -0800
Message-ID: <200802052226.m15MQRcw011625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761076AbYBEW0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timerfd: un-break CONFIG_TIMERFD
has been removed from the -mm tree.  Its filename was
     timerfd-v3-un-break-config_timerfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -582,7 +582,6 @@ config SIGNALFD
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
 	select ANON_INODES
-	depends on BROKEN
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
timerfd-fix-remaining-architectures.patch
git-kvm.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
