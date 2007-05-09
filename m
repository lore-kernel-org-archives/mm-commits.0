From: akpm@linux-foundation.org
Subject: - lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch removed from -mm tree
Date: Wed, 09 May 2007 02:44:14 -0700
Message-ID: <200705090944.l499iEWj020240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbXEIJok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix lguest documentation error
has been removed from the -mm tree.  Its filename was
     lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

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

origin.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
lguest-the-net-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-two-net-bugfixes-doc.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
