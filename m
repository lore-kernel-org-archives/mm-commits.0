From: akpm@linux-foundation.org
Subject: [merged] maintainers-microblaze-use-lkml-as-mailing-list.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:10 -0700
Message-ID: <533f08f6.myZ92ZCcbdhA2EP1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaDDTdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, michal.simek@xilinx.com

Subject: [merged] maintainers-microblaze-use-lkml-as-mailing-list.patch removed from -mm tree
To: michal.simek@xilinx.com,rgb@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:10 -0700


The patch titled
     Subject: MAINTAINERS: microblaze: use LKML as mailing list
has been removed from the -mm tree.  Its filename was
     maintainers-microblaze-use-lkml-as-mailing-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5761,7 +5761,6 @@ F:	fs/imgdafs/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
-L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
linux-next.patch

