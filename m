From: akpm@linux-foundation.org
Subject: - mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:04 -0800
Message-ID: <200802082014.m18KEjWb010482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYBHUtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: allocate serial port UART IDs for on-chip serial ports
has been removed from the -mm tree.  Its filename was
     mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: allocate serial port UART IDs for on-chip serial ports
From: David Howells <dhowells@redhat.com>

Allocate serial port UART type IDs for the MN10300 on-chip serial ports.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/serial_core.h~mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports include/linux/serial_core.h
--- a/include/linux/serial_core.h~mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports
+++ a/include/linux/serial_core.h
@@ -150,6 +150,10 @@
 #define PORT_MCF	78
 
 
+/* MN10300 on-chip UART numbers */
+#define PORT_MN10300		80
+#define PORT_MN10300_CTS	81
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
