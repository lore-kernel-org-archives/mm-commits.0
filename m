From: akpm@linux-foundation.org
Subject: + maintainers-remove-website-for-paride.patch added to -mm tree
Date: Wed, 29 Apr 2015 16:30:48 -0700
Message-ID: <554169a8.Nbo4N1VJn5byHqKy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbD2Xat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 19:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove website for paride
has been added to the -mm tree.  Its filename is
     maintainers-remove-website-for-paride.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-website-for-paride.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-website-for-paride.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: MAINTAINERS: remove website for paride

The webpage mentioned is not working,

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-website-for-paride MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-website-for-paride
+++ a/MAINTAINERS
@@ -7380,7 +7380,6 @@ F:	arch/*/include/asm/paravirt.h
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 M:	Tim Waugh <tim@cyberelk.net>
 L:	linux-parport@lists.infradead.org (subscribers-only)
-W:	http://www.torque.net/linux-pp.html
 S:	Maintained
 F:	Documentation/blockdev/paride.txt
 F:	drivers/block/paride/
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

maintainers-remove-website-for-paride.patch

