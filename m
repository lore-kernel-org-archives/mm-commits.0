Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7D318C34B
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729288571; cv=none; b=ks6zuUvFgLdTgUL2j1yb2PNCTAw2FTpNyEGoj9z1ggNjflQWgTNgo8uLSVU6v0sCRKhJk2AmBWLEAuriCxF1thrSbIJToGWTsCOYCA32XRuiKpDJ473vg8mYLNz9JkvV9nwUZ6W6+114sTGB1DtkXEwShBaecTQMku3/Ow4ZkP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729288571; c=relaxed/simple;
	bh=t1GEUnnCqlMps/fQBG6E3XaueLIxn8mZFUdgP6DrgO4=;
	h=Date:To:From:Subject:Message-Id; b=NpoFxo/jidIHRx4LZdztEpf4Q/610i/pcpwJNgnykTvl2/fNElkcdSyJ7FbIw/dWYyfyN2rPtpvOU2ewu/B2nhUgqTEjMMu+AzW53bn/ZwKb0EijOx2erDi7ZX9j+oBWzsUJiT1qGJ7+X9G0lUsDxXK+tHOnu1aEGk3n4ObOCsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xFpfH+rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xFpfH+rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671F2C4CEC3;
	Fri, 18 Oct 2024 21:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729288570;
	bh=t1GEUnnCqlMps/fQBG6E3XaueLIxn8mZFUdgP6DrgO4=;
	h=Date:To:From:Subject:From;
	b=xFpfH+rzvweIJb2KfcvYicAOcCSdksbGOeiZodMtYdqPlCnWMRoHXh0D/JJZIyZWG
	 C6cLA+TYhqfyTnSfSKcBgga1EjLs1ASl/7yoUxMwWPPqA84JbR8WI5pmvddgnHxKSf
	 cehsldi4e9DDi1dhzt55EffJyHDgzqBAR4gEEcMw=
Date: Fri, 18 Oct 2024 14:56:09 -0700
To: mm-commits@vger.kernel.org,jesse.brandeburg@intel.com,horms@kernel.org,colin.i.king@gmail.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch added to mm-nonmm-unstable branch
Message-Id: <20241018215610.671F2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: add typo "exprienced" and "rewritting"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: WangYuli <wangyuli@uniontech.com>
Subject: scripts/spelling.txt: add typo "exprienced" and "rewritting"
Date: Fri, 18 Oct 2024 10:47:19 +0800

Add typo "exprienced" and "rewritting".
They were found and fixed in follow patches:

Link: https://lore.kernel.org/all/90D42CB167CA0842+20241018021910.31359-1-wangyuli@uniontech.com/
Link: https://lore.kernel.org/all/45F06B5D4CA9F444+20241018023340.47617-1-wangyuli@uniontech.com/
Link: https://lkml.kernel.org/r/C1FE2459CF066CA5+20241018024719.58325-1-wangyuli@uniontech.com
Link: https://lore.kernel.org/all/20241017162846.GA51712@kernel.org/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Suggested-by: Simon Horman <horms@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-typo-exprienced-and-rewritting
+++ a/scripts/spelling.txt
@@ -674,6 +674,7 @@ explict||explicit
 explictely||explicitly
 explictly||explicitly
 expresion||expression
+exprienced||experienced
 exprimental||experimental
 extened||extended
 exteneded||extended
@@ -1388,6 +1389,7 @@ reuest||request
 reuqest||request
 reutnred||returned
 revsion||revision
+rewritting||rewriting
 rmeoved||removed
 rmeove||remove
 rmeoves||removes
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch

