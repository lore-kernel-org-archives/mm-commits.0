From: akpm@linux-foundation.org
Subject: + lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:35:19 -0700
Message-ID: <200704280135.l3S1ZJTk012627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030856AbXD1BfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, rusty@rustcorp.com.au


The patch titled
     Fix lguest documentation error
has been added to the -mm tree.  Its filename is
     lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix lguest documentation error
From: James Morris <jmorris@namei.org>

Fix up nat example in documentation.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/lguest/lguest.txt~lguest-the-documentation-example-launcher-fix-lguest-documentation-error Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt~lguest-the-documentation-example-launcher-fix-lguest-documentation-error
+++ a/Documentation/lguest/lguest.txt
@@ -69,7 +69,7 @@ Running Lguest:
        kernel boot parameters.
 
 - Configuring networking.  I usually have the host masquerade, using
-  "iptables -t nat -o eth0 -j MASQUERADE" and "echo 1 >
+  "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" and "echo 1 >
   /proc/sys/net/ipv4/ip_forward".  In this example, I would configure
   eth0 inside the guest at 192.168.19.2.
 
_

Patches currently in -mm which might be from jmorris@namei.org are

security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
git-net.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
return-eperm-not-echild-on-security_task_wait-failure.patch
return-eperm-not-echild-on-security_task_wait-failure-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
