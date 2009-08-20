From: akpm@linux-foundation.org
Subject: + maintainers-remove-dead-ncpfs-list.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:44:55 -0700
Message-ID: <200908202144.n7KLitS5015518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbZHTVp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, linware@sh.cvut.cz, vandrove@vc.cvut.cz


The patch titled
     MAINTAINERS: remove dead ncpfs list
has been added to the -mm tree.  Its filename is
     maintainers-remove-dead-ncpfs-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3550,7 +3550,6 @@ F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-L:	linware@sh.cvut.cz
 S:	Maintained
 F:	fs/ncpfs/
 
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
linux-next.patch
maintainers-remove-dead-ncpfs-list.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

