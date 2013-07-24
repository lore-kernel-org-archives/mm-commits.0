From: akpm@linux-foundation.org
Subject: + maintainers-add-linux-metag-mailing-list.patch added to -mm
 tree
Date: Wed, 24 Jul 2013 14:21:00 -0700
Message-ID: <51f0453c.vprXTL8/n0bs2jS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXVVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com

Subject: + maintainers-add-linux-metag-mailing-list.patch added to -mm tree
To: james.hogan@imgtec.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:21:00 -0700


The patch titled
     Subject: MAINTAINERS: add linux-metag mailing list
has been added to the -mm tree.  Its filename is
     maintainers-add-linux-metag-mailing-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-linux-metag-mailing-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-linux-metag-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: MAINTAINERS: add linux-metag mailing list

Add the new linux-metag@vger.kernel.org mailing list to METAG ARCHITECTURE
entry in MAINTAINERS.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-linux-metag-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-linux-metag-mailing-list
+++ a/MAINTAINERS
@@ -5391,6 +5391,7 @@ F:	drivers/watchdog/mena21_wdt.c
 
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
+L:	linux-metag@vger.kernel.org
 S:	Supported
 F:	arch/metag/
 F:	Documentation/metag/
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

maintainers-add-linux-metag-mailing-list.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
linux-next.patch

