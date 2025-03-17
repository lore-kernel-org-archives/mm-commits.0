Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262B140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189534; cv=none; b=lVawhRUdnPGJ0PojNs+90ZXLOUt/gTsRCrUx/DoAxQL+ClFUMQKP8JSZuq1eW8/r7V3sxyh+JuQg1o92ZKfUjF6+1wKoFPruypFAO8Gb28v2Z2iGMs5uWEUsIXJS43PQ+RGqumYOBnzckRIED4Vq2sNAqPrkfPYry8cq2Gfuu4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189534; c=relaxed/simple;
	bh=Hx7peKhVY9MsuMYFNouilZ13JW3SOXLLzjw3JFt8e+A=;
	h=Date:To:From:Subject:Message-Id; b=XFs+h2ybdN/wNDNl6WbrsnjTuBZU+QwBNkJhrgyzp2fPN2wQmYVzznpfji1FVblJGzEjx1UCRWfFHm5bNsF9Nyul+EjWZnhPpVFBonBeO0gW86getuSvzkliZYeS+5XOjBx0Hxd8c3dRa1cY7B5xJ09HFP+58VHfD1gwVFD4pnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9cwQ2ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9cwQ2ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4935DC4CEEC;
	Mon, 17 Mar 2025 05:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189534;
	bh=Hx7peKhVY9MsuMYFNouilZ13JW3SOXLLzjw3JFt8e+A=;
	h=Date:To:From:Subject:From;
	b=T9cwQ2ui4tbrz4x5L1ucm76pzIMcnhrgxD3vbE/kzi+7LsmsVUyiO9OTPCxZVS9iF
	 G4CZS5rAP3tz9fCpgoSJOUfWsUgMDGexFqPhC9d+jltEXuVbJxCMtr0eaNTknxIn6O
	 e5ty/qNzFg5D53O8R9ol97YzzFTpRxlhsNKOtTpE=
Date: Sun, 16 Mar 2025 22:32:13 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,dev.jain@arm.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-mailmap-update-hyeonggons-name-and-email-address.patch removed from -mm tree
Message-Id: <20250317053214.4935DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update Hyeonggon's name and email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-hyeonggons-name-and-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: MAINTAINERS: mailmap: update Hyeonggon's name and email address
Date: Wed, 19 Feb 2025 16:17:02 +0900

Update my Korean name and personal email address to my English name and
Oracle email address.

Link: https://lkml.kernel.org/r/20250219071702.964344-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo (Oracle) <42.hyeyoo@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-hyeonggons-name-and-email-address
+++ a/.mailmap
@@ -269,6 +269,7 @@ Hamza Mahfooz <hamzamahfooz@linux.micros
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Hans Verkuil <hverkuil@xs4all.nl> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@xs4all.nl> <hverkuil-cisco@xs4all.nl>
+Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
 Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
--- a/MAINTAINERS~maintainers-mailmap-update-hyeonggons-name-and-email-address
+++ a/MAINTAINERS
@@ -21812,7 +21812,7 @@ M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Hyeonggon Yoo <42.hyeyoo@gmail.com>
+R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


