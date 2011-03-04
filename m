From: akpm@linux-foundation.org
Subject: + rapidio-update-maintainers.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:56:08 -0800
Message-ID: <201103042356.p24Nu8vl011350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760032Ab1CDX4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org


The patch titled
     RapidIO: Update MAINTAINERS
has been added to the -mm tree.  Its filename is
     rapidio-update-maintainers.patch

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
Subject: RapidIO: Update MAINTAINERS
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~rapidio-update-maintainers MAINTAINERS
--- a/MAINTAINERS~rapidio-update-maintainers
+++ a/MAINTAINERS
@@ -5208,6 +5208,7 @@ F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 M:	Matt Porter <mporter@kernel.crashing.org>
+M:	Alexandre Bounine <alexandre.bounine@idt.com>
 S:	Maintained
 F:	drivers/rapidio/
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-update-maintainers.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

