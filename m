From: akpm@linux-foundation.org
Subject: + parisc-maintainers-updates.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:14:43 -0800
Message-ID: <200811242214.mAOMEhOu018538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbYKXWPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grundler@parisc-linux.org, deller@gmx.de, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     parisc: MAINTAINERS updates
has been added to the -mm tree.  Its filename is
     parisc-maintainers-updates.patch

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
Subject: parisc: MAINTAINERS updates
From: Grant Grundler <grundler@parisc-linux.org>

- Matthew sayeth "I think it's time to remove me from MAINTAINERS as
  it's probably been six months since I last turned on any of my parisc
  machines"

- Grant recruiteth Helge, Helge objecteth insifficiently.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Reviewed-by: Matthew Wilcox <matthew@wil.cx>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~parisc-maintainers-updates MAINTAINERS
--- a/MAINTAINERS~parisc-maintainers-updates
+++ a/MAINTAINERS
@@ -3313,8 +3313,8 @@ S:	Maintained
 PARISC ARCHITECTURE
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
-P:	Matthew Wilcox
-M:	matthew@wil.cx
+P:	Helge Deller
+M:	deller@gmx.de
 P:	Grant Grundler
 M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

linux-next.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2.patch
parisc-maintainers-updates.patch
unaligned-introduce-common-header.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch

