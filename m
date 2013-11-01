From: akpm@linux-foundation.org
Subject: + scripts-tagssh-remove-obsolete-__devinit.patch added to -mm
 tree
Date: Fri, 01 Nov 2013 16:19:33 -0700
Message-ID: <52743705.O+cXx8LhL0WVuDLQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3KAXTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 19:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, michael.opdenacker@free-electrons.com

Subject: + scripts-tagssh-remove-obsolete-__devinit.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,mmarek@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 16:19:33 -0700


The patch titled
     Subject: scripts/tags.sh: remove obsolete __devinit[const|data]
has been added to the -mm tree.  Its filename is
     scripts-tagssh-remove-obsolete-__devinit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-remove-obsolete-__devinit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-remove-obsolete-__devinit.patch

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
Subject: scripts/tags.sh: remove obsolete __devinit[const|data]

This removes the use of __devinitconst and __devinitdata in scripts/tags.sh,
which were removed in 3.8.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-remove-obsolete-__devinit scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-remove-obsolete-__devinit
+++ a/scripts/tags.sh
@@ -149,8 +149,8 @@ dogtags()
 exuberant()
 {
 	all_target_sources | xargs $1 -a                        \
-	-I __initdata,__exitdata,__initconst,__devinitdata	\
-	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
+	-I __initdata,__exitdata,__initconst			\
+	-I __cpuinitdata,__initdata_memblock			\
 	-I __refdata,__attribute				\
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
cramfs-mark-as-obsolete.patch
init-make-init-failures-more-explicit.patch
scripts-tagssh-remove-obsolete-__devinit.patch
linux-next.patch

