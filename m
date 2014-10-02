From: akpm@linux-foundation.org
Subject: + maintainers-remove-chirag-kantharia-invalid-e-mail.patch added
 to -mm tree
Date: Thu, 02 Oct 2014 13:38:27 -0700
Message-ID: <542db7c3.n/V6yTIE/r56QfEE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaJBUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2014 16:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove Chirag Kantharia, invalid e-mail
has been added to the -mm tree.  Its filename is
     maintainers-remove-chirag-kantharia-invalid-e-mail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-chirag-kantharia-invalid-e-mail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-chirag-kantharia-invalid-e-mail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: MAINTAINERS: remove Chirag Kantharia, invalid e-mail

This removes Chirag Kantharia from the MAINTAINERS file, as his e-mail
address is now rejected by the HP mail server.

Make the driver "Orphan" until he gets back with a working e-mail address
or a new maintainer steps in.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-chirag-kantharia-invalid-e-mail MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-chirag-kantharia-invalid-e-mail
+++ a/MAINTAINERS
@@ -4220,9 +4220,8 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/hd29l2*
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
-M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
-S:	Maintained
+S:	Orphan
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

m32r-remove-deprecated-irqf_disabled.patch
score-remove-deprecated-irqf_disabled.patch
frv-remove-deprecated-irqf_disabled.patch
maintainers-orphan-m32r.patch
maintainers-remove-chirag-kantharia-invalid-e-mail.patch
linux-next.patch

