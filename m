Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED654654
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771623702; cv=none; b=TfA2UJXLV59GZ0+tytMFtUU/6r/t6oowH/yyydSMv+mgDgFCtNpwgkCgjf8T/1eeMpHkXEVjxblXyaivKPYNWpKW/BhMqIKJnhgt4mMH1bJcG/1rzH9ez5GkBnl2Ae62snhBog1AN77tbaHI/fEzdpbob82hQSXmd2yHcsjB5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771623702; c=relaxed/simple;
	bh=5LAdtie+L8QoqcLkVBChFP7gfadIpt2kxprOTBn1G1M=;
	h=Date:To:From:Subject:Message-Id; b=dycszvsxFE+ZvtRp2lx0D9w6ohqFa+DqdPLSvXS8f3CWKqCCVFChLTCMG5bzndl014rk0xpl/ERvkPRW+Kj/jpWUogX2YQscTg12DK+AbMO/CcbRP4r6Q9fvVBj8lrLo1qG7m2u/CKgjFTYhgWwAtX4NfNBqw4lE+oBYfoiXzR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mHZ/YIvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mHZ/YIvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757E7C116C6;
	Fri, 20 Feb 2026 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771623702;
	bh=5LAdtie+L8QoqcLkVBChFP7gfadIpt2kxprOTBn1G1M=;
	h=Date:To:From:Subject:From;
	b=mHZ/YIvTUcx8VBEDAGXqN7l+kwbhvu5DfE7xeYWgZQGWLcKVPuWUeWD/usEWjF40l
	 DYxsnROGQ+TjH46BiFCJBycNhw3gjofyNNZFwWQRChaD6KgotVQuFgyaESKhH54IZK
	 tyCSqIQ6Ujd0MwnL3xKy2VSkdaoRSl/Qy8A/YP5c=
Date: Fri, 20 Feb 2026 13:41:41 -0800
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,Jonathan.Cameron@huawei.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-exaclty-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20260220214142.757E7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: add "exaclty" typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-exaclty-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-exaclty-typo.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: scripts/spelling.txt: add "exaclty" typo
Date: Thu, 12 Feb 2026 15:40:05 +0100

Link: https://lkml.kernel.org/r/20260212144005.45052-2-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Jonathan Camerom <Jonathan.Cameron@huawei.com>
Cc: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-exaclty-typo
+++ a/scripts/spelling.txt
@@ -654,6 +654,7 @@ evalute||evaluate
 evalutes||evaluates
 evalution||evaluation
 evaulated||evaluated
+exaclty||exactly
 excceed||exceed
 excecutable||executable
 exceded||exceeded
_

Patches currently in -mm which might be from pvorel@suse.cz are

scripts-spellingtxt-sort-alphabetically.patch
scripts-spellingtxt-add-exaclty-typo.patch

