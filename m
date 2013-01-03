From: akpm@linux-foundation.org
Subject: + documentation-cgroups-blkio-controllertxt-fix-typo.patch added to -mm tree
Date: Thu, 03 Jan 2013 14:04:45 -0800
Message-ID: <20130103220445.926E682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61354 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3ACWEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 17:04:46 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so1710665qaq.3
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 14:04:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wt@ooyala.com


The patch titled
     Subject: Documentation/cgroups/blkio-controller.txt: fix typo
has been added to the -mm tree.  Its filename is
     documentation-cgroups-blkio-controllertxt-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Warren Turkal <wt@ooyala.com>
Subject: Documentation/cgroups/blkio-controller.txt: fix typo

Signed-off-by: Warren Turkal <wt@ooyala.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/blkio-controller.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/blkio-controller.txt~documentation-cgroups-blkio-controllertxt-fix-typo Documentation/cgroups/blkio-controller.txt
--- a/Documentation/cgroups/blkio-controller.txt~documentation-cgroups-blkio-controllertxt-fix-typo
+++ a/Documentation/cgroups/blkio-controller.txt
@@ -75,7 +75,7 @@ Throttling/Upper Limit policy
         mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Specify a bandwidth rate on particular device for root group. The format
-  for policy is "<major>:<minor>  <byes_per_second>".
+  for policy is "<major>:<minor>  <bytes_per_second>".
 
         echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
 
_

Patches currently in -mm which might be from wt@ooyala.com are

documentation-cgroups-blkio-controllertxt-fix-typo.patch

