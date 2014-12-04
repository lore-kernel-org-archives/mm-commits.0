From: akpm@linux-foundation.org
Subject: + uapi-fix-to-export-linux-vm_socketsh.patch added to -mm tree
Date: Thu, 04 Dec 2014 14:41:26 -0800
Message-ID: <5480e316.wxQuHgwugzTz2CDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaLDWl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Dec 2014 17:41:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.m@jp.panasonic.com, davem@davemloft.net, stephen@networkplumber.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: fix to export linux/vm_sockets.h
has been added to the -mm tree.  Its filename is
     uapi-fix-to-export-linux-vm_socketsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uapi-fix-to-export-linux-vm_socketsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uapi-fix-to-export-linux-vm_socketsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: uapi: fix to export linux/vm_sockets.h

A typo "header=y" was introduced by commit 7071cf7fc435 ("uapi: add
missing network related headers to kbuild").

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/Kbuild |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/Kbuild~uapi-fix-to-export-linux-vm_socketsh include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~uapi-fix-to-export-linux-vm_socketsh
+++ a/include/uapi/linux/Kbuild
@@ -432,7 +432,7 @@ header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
 header-y += virtio_rng.h
-header=y += vm_sockets.h
+header-y += vm_sockets.h
 header-y += vt.h
 header-y += wait.h
 header-y += wanrouter.h
_

Patches currently in -mm which might be from yamada.m@jp.panasonic.com are

uapi-fix-to-export-linux-vm_socketsh.patch
linux-next.patch

