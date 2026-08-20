Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A1348C70
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787194536; cv=none; b=k3OrA32z8fOLIlAKwy4JpQ1mdTKDNI3ni8Ph4CVluO5ORJ+NU/LwoICHrdexDSgD+wZnWxq3s/OGAaY550vevykg+1lAMrqKMesc7wWjMv9QA32TCmQN51swtdxnnOxPHD4M1HcOuXzVGBH0Vx++Dm5Nvk2NNSMxSDgCEdAn2eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787194536; c=relaxed/simple;
	bh=2RxzUvnJUXcaCLn1YkPih7bX3RLH0L88slI2GaefFhM=;
	h=Date:To:From:Subject:Message-Id; b=souY/G2xdOeYi4RKnCuzVEnzYVxj/K0EiC+qv5kfBzZ4CeBygNpEfgXfKMirakxrEoFD45c6fZUNvlEcBKU9EGMrk1AAbkxYfj4MYL82ObJhcrbtNk2pE6AJR88whXrvN7h0HCdvD4R6rOfL/KqnSVCAaEcUrQDvDrEpNLqOh4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwM73T7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwM73T7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191B71F00A3A;
	Thu, 20 Aug 2026 02:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787194534;
	bh=YXWAC2uLb4zxBObvgt3mdfJOgS8SFsVMKCtWZHk8Qhc=;
	h=Date:To:From:Subject;
	b=qwM73T7fLLdyzqne/VGK4c5LplGrxTsFbk5CwdZC4X7fh8z8Wu1uW0rZeju5V0L2u
	 K5vHQvySSJRtwzvwnBaWBidfOWRzgPh4gIREbnmJb7vcRBN71P8DfxSjZkYfLo8c3r
	 0dlfKiCbjoTGKx1ZyZjtescm9QZ0ImuyfTYnOrU8=
Date: Wed, 19 Aug 2026 19:55:33 -0700
To: mm-commits@vger.kernel.org,linfeng.sun.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-address-for-linfeng-sun.patch removed from -mm tree
Message-Id: <20260820025534.191B71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Linfeng Sun
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-linfeng-sun.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
Subject: mailmap: update email address for Linfeng Sun
Date: Mon, 10 Aug 2026 15:32:35 +0800

1. Update my university email to my personal Gmail, as the former will
   expire after graduation.
2. Fix a typo in my Gmail domain.

Link: https://lore.kernel.org/20260810073235.22980-1-linfeng.sun.dev@gmail.com
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-linfeng-sun
+++ a/.mailmap
@@ -516,6 +516,8 @@ Leo Yan <leo.yan@linux.dev> <leo.yan@lin
 Liam R. Howlett <liam@infradead.org> <Liam.Howlett@oracle.com>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
+Linfeng Sun <linfeng.sun.dev@gmail.com> <slf@hdu.edu.cn>
+Linfeng Sun <linfeng.sun.dev@gmail.com> <linfeng.sun.dev@gamil.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
 Linus Lüssing <linus.luessing@c0d3.blue> <ll@simonwunderlich.de>
_

Patches currently in -mm which might be from linfeng.sun.dev@gmail.com are


