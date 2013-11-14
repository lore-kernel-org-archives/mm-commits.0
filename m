From: akpm@linux-foundation.org
Subject: [merged] scripts-tagssh-remove-obsolete-__devinit.patch removed
 from -mm tree
Date: Thu, 14 Nov 2013 12:05:37 -0800
Message-ID: <52852d11.W90tEg+L0obdzYRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3KNUFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 15:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, michael.opdenacker@free-electrons.com

Subject: [merged] scripts-tagssh-remove-obsolete-__devinit.patch removed from -mm tree
To: michael.opdenacker@free-electrons.com,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 12:05:37 -0800


The patch titled
     Subject: scripts/tags.sh: remove obsolete __devinit[const|data]
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-remove-obsolete-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+	-I __initdata,__exitdata,__initconst,			\
+	-I __cpuinitdata,__initdata_memblock			\
 	-I __refdata,__attribute,__maybe_unused,__always_unused \
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
drivers-cdrom-gdromc-remove-deprecated-irqf_disabled.patch
linux-next.patch

