From: akpm@linux-foundation.org
Subject: + maintainers-microblaze-use-lkml-as-mailing-list.patch added to
 -mm tree
Date: Fri, 21 Mar 2014 13:17:56 -0700
Message-ID: <532c9e74.lwrRUJTiJD55lFEK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaCUUR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 16:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, michal.simek@xilinx.com

Subject: + maintainers-microblaze-use-lkml-as-mailing-list.patch added to -mm tree
To: michal.simek@xilinx.com,rgb@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 13:17:56 -0700


The patch titled
     Subject: MAINTAINERS: microblaze: use LKML as mailing list
has been added to the -mm tree.  Its filename is
     maintainers-microblaze-use-lkml-as-mailing-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-microblaze-use-lkml-as-mailing-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-microblaze-use-lkml-as-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: MAINTAINERS: microblaze: use LKML as mailing list

microblaze-uclinux mailing list is almost dead and it is just causing
troubles for non subscribers which are getting email about waiting for
moderator.  Approval never happens.  Move it to LKML.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reported-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-microblaze-use-lkml-as-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-microblaze-use-lkml-as-mailing-list
+++ a/MAINTAINERS
@@ -5725,7 +5725,6 @@ F:	fs/imgdafs/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
-L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

maintainers-microblaze-use-lkml-as-mailing-list.patch
linux-next.patch

