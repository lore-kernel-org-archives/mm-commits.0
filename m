Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEBE2F691D
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023167; cv=none; b=QorbjtCQ+K8FrSJLP/+xJjHfsYBv/tK53E/sBIvcgMq07aRq2O5Btaa7Rys4B7gEym6BUQs7X8zepCrDZ54Da18PfwLvH4QoiQ7JY2cDDGfrFBCN6tDEgliv9pAd63nAGHoYygj8uwZ0Gm0D++rnqYNBLuOX+Va/otLenD+Kvxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023167; c=relaxed/simple;
	bh=RGAzTbmnbiVmF9rfJbKlJTFW7D2v2SewkvbLExegoQE=;
	h=Date:To:From:Subject:Message-Id; b=m8ScSnbzdcquE+5JXfcnwpV8qdJ8if1wr6o5FAr2oRC1X33nDMM/nrv7Tl6Jyq8qlzu0JSz5wCFLS2HUStbhOVuM2AzNFTVU0vA4oftn6PpjvYwOQNYwAvVyGX0N9Adqp0JwaHXNYW5ZLLy9yvmvdL8KN19/FjwNLl1Psz+Ys18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgWaX9sM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgWaX9sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9496C4CEFB;
	Mon, 24 Nov 2025 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023164;
	bh=RGAzTbmnbiVmF9rfJbKlJTFW7D2v2SewkvbLExegoQE=;
	h=Date:To:From:Subject:From;
	b=CgWaX9sMBfxDUby+lmLi1Pa0iAfS4pdU0TYMIquxzsMMDsxL6qsWFMgOHmelkFZEJ
	 7eQvs7vss3GzsNNKjT/YJn9cj8PatGbzqCxKDn9Lm6j0vLteLehFNSZEnCTXtXQPxT
	 miUWMt+EWy7M8wtoxoCbNGIPj/FAhI7CVfkGmXkM=
Date: Mon, 24 Nov 2025 14:26:04 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,semen.protsenko@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-sam-protsenko.patch removed from -mm tree
Message-Id: <20251124222604.A9496C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Sam Protsenko
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-sam-protsenko.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: mailmap: add entry for Sam Protsenko
Date: Mon, 17 Nov 2025 21:31:11 -0600

Use 'Sam Protsenko' as my name consistently in git-shortlog.  Also map my
old GlobalLogic email address to my current email to stay reachable.

Link: https://lkml.kernel.org/r/20251118033111.23382-1-semen.protsenko@linaro.org
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-sam-protsenko
+++ a/.mailmap
@@ -689,6 +689,8 @@ Sachin Mokashi <sachin.mokashi@intel.com
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
+Sam Protsenko <semen.protsenko@linaro.org>
+Sam Protsenko <semen.protsenko@linaro.org> <semen.protsenko@globallogic.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sankeerth Billakanti <quic_sbillaka@quicinc.com> <sbillaka@codeaurora.org>
 Santosh Shilimkar <santosh.shilimkar@oracle.org>
_

Patches currently in -mm which might be from semen.protsenko@linaro.org are


