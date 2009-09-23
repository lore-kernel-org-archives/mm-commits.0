From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-dead-ncpfs-list.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:08 -0700
Message-ID: <200909231953.n8NJr8wT030559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbZIWTx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, linware@sh.cvut.cz, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove dead ncpfs list
has been removed from the -mm tree.  Its filename was
     maintainers-remove-dead-ncpfs-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove dead ncpfs list
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

On Saturday 01 August 2009 00:30:39 Mail Delivery Subsystem wrote:
> Delivery to the following recipient failed permanently:
>
>      linware@sh.cvut.cz
>
> Technical details of permanent failure:
> Google tried to deliver your message, but it was rejected by the recipient
> domain. We recommend contacting the other email provider for further
> information about the cause of this error. The error that the other server
> returned was: 450 450 <linware@sh.cvut.cz>: Recipient address rejected:
> undeliverable address: unknown user: "linware" (state 14).

Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-dead-ncpfs-list MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-dead-ncpfs-list
+++ a/MAINTAINERS
@@ -3527,7 +3527,6 @@ F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-L:	linware@sh.cvut.cz
 S:	Maintained
 F:	fs/ncpfs/
 
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
ide-use-printk_once.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

