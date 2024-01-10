Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D0D3C2F
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8My+zKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B89C43390;
	Wed, 10 Jan 2024 05:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865194;
	bh=RVQwKf3Vmc7g7XM5MSM9sOSBg6lqwJFJugqZWB4vWlM=;
	h=Date:To:From:Subject:From;
	b=b8My+zKCi7xkD93AayDO/OtBa0uyxY3aOEBSIrb9e4su2sbD3ee+iqLAIBLWbqzDU
	 /Zjf542IPrBXk65LibMC/pIUqzOOBnJ3ps9/wKbtAHCDud7FKFrt58l4+46Vmy6Gvf
	 gwskvNolAZJTq8YPaluoK9l8jTP6VLhiqbpBpd44=
Date: Tue, 09 Jan 2024 21:39:53 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-old-address-mappings-for-myself.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110053954.21B89C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add old address mappings for Randy
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-old-address-mappings-for-myself.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-old-address-mappings-for-myself.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mailmap: add old address mappings for Randy
Date: Fri, 5 Jan 2024 22:30:44 -0800

Add my old email addresses so that git send-email will map them
to my current email address.

Link: https://lkml.kernel.org/r/20240106063051.13623-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-old-address-mappings-for-myself
+++ a/.mailmap
@@ -503,6 +503,9 @@ Ralf Baechle <ralf@linux-mips.org>
 Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
 Ram Chandra Jangir <quic_rjangir@quicinc.com> <rjangir@codeaurora.org>
 Randy Dunlap <rdunlap@infradead.org> <rdunlap@xenotime.net>
+Randy Dunlap <rdunlap@infradead.org> <randy.dunlap@oracle.com>
+Randy Dunlap <rdunlap@infradead.org> <rddunlap@osdl.org>
+Randy Dunlap <rdunlap@infradead.org> <randy.dunlap@intel.com>
 Ravi Kumar Bokka <quic_rbokka@quicinc.com> <rbokka@codeaurora.org>
 Ravi Kumar Siddojigari <quic_rsiddoji@quicinc.com> <rsiddoji@codeaurora.org>
 Rémi Denis-Courmont <rdenis@simphalempin.com>
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mailmap-add-old-address-mappings-for-myself.patch
lib-win_minmax-fix-header-comments.patch

