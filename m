Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF662AEFD
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750629018; cv=none; b=o1QJgeikLd9gWnv+6zJ15QzveL8HbR3I6LY/OwjCgchfKJuRpAOYvCjsp8LrJQGAEBDRJLCiM0L8LikNNFLjr1tufFXczENFmnXJhViou0DYgBs3xOq/xaIg0tCGlxJacUkYnpgebYRjF/pjwg950ONJh508hPoPGzQ+QDIH0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750629018; c=relaxed/simple;
	bh=JxG5Lr4PTZhS255q4lggPtuo/DD6j+wWBdLey1U3ehQ=;
	h=Date:To:From:Subject:Message-Id; b=RD6RR7T3tqAggOznTo4pEMmzlvLZbrynLalRdXMZJAZEJk2ZCi+uUwH++oyK5SBsILejRjAtjFC60jzBGWYj/xBCu2snHOL6TBw7LUA45mYtR44QdRdkWj0UTwWcuh5vEaIZ2QQw3cUlXp5Kny4bFOZN4qTdZnjeoJQ9xWYnyns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+R5p21J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+R5p21J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFBC4CEE3;
	Sun, 22 Jun 2025 21:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750629018;
	bh=JxG5Lr4PTZhS255q4lggPtuo/DD6j+wWBdLey1U3ehQ=;
	h=Date:To:From:Subject:From;
	b=M+R5p21JoPMzMGQ2p6/TOGVdDsZKhfV0bkP6X7sKRe9rNHeCHSbYc4DyWzPiY9t1G
	 efxTc/VBc9xuXV4l8K04Dy0QUAzayBSjFCU7UuSW2Yx5DsyvZHwPnFWWHOgfphjmcg
	 eMah1su3FVP5wTmvmawomhiig1x7uOfI8gWlFUtE=
Date: Sun, 22 Jun 2025 14:50:17 -0700
To: mm-commits@vger.kernel.org,hverkuil@xs4all.nl,zijun.hu@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622215018.16CFBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: correct name for a historical account of Zijun Hu
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch

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
From: Zijun Hu <zijun.hu@oss.qualcomm.com>
Subject: mailmap: correct name for a historical account of Zijun Hu
Date: Fri, 20 Jun 2025 19:53:54 +0800

Correct the name for <zijun_hu@htc.com> from 'zijun_hu' to 'Zijun Hu'.

Link: https://lkml.kernel.org/r/20250620-my_mailmap-v1-2-11ea3db8ba1e@oss.qualcomm.com
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Cc: Hans verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-correct-name-for-a-historical-account-of-zijun-hu
+++ a/.mailmap
@@ -829,3 +829,4 @@ Zack Rusin <zack.rusin@broadcom.com> <za
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
 Zijun Hu <zijun.hu@oss.qualcomm.com> <quic_zijuhu@quicinc.com>
 Zijun Hu <zijun.hu@oss.qualcomm.com> <zijuhu@codeaurora.org>
+Zijun Hu <zijun_hu@htc.com>
_

Patches currently in -mm which might be from zijun.hu@oss.qualcomm.com are

mailmap-add-entries-for-zijun-hu.patch
mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch

