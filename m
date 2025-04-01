Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A981B1D79B8
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743546074; cv=none; b=WmFM4zLhQxPlkuF9EsV1kZa1mjwb49l7t+c9SKQShdS5qAURZivgC82wz+xlnSldd16lwVqLkvLPewqSMqcvrM78gmaijr5B2aRJ2jdsXYsHLT55zTFf5M1CDYuUOEYeL6fyMNvUMQk4K+srjQXuwM0KSj7Dbu2cXXlZZ4seyjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743546074; c=relaxed/simple;
	bh=0L3B9CIVEH4N8YSQ/x+6Me0cQkNYA+5FEWe1TO9f468=;
	h=Date:To:From:Subject:Message-Id; b=pmq4zOItuYYq7T20/ILQUVnv//5S/uH+1GCkiBG3VHtcMzuhb6SgID+4wmHm91j1LAJXnAA2RgsHZcUnemqMHj5vO/+3XX/xpqIQMrDUdO+4G3/ZSvpKoMFigaPLPt5RwfWN8SlhI63FNqXmap2OiKP81HGp6LXTJUj0ZF8rhTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WglHT4c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WglHT4c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E317AC4CEE4;
	Tue,  1 Apr 2025 22:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743546074;
	bh=0L3B9CIVEH4N8YSQ/x+6Me0cQkNYA+5FEWe1TO9f468=;
	h=Date:To:From:Subject:From;
	b=WglHT4c08fJVjeaGka09+0YcWfVGb7KZ+5USuH9xnFTUTH1+o/BhPMbXAfz1wryyx
	 5BHiDYW2qnCYlHi8YSBD3T/nNVKmRZdhjGfVoY+M/RoZhURA/bn4zFSMoASgjmmT3C
	 wI9su6MQAFi8/dRHqPVRXNfLOz2FdoBZKKWKleds=
Date: Tue, 01 Apr 2025 15:21:13 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-an-entry-for-nicolas-schier.patch removed from -mm tree
Message-Id: <20250401222113.E317AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add an entry for Nicolas Schier
has been removed from the -mm tree.  Its filename was
     mailmap-add-an-entry-for-nicolas-schier.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicolas Schier <nicolas@fjasle.eu>
Subject: mailmap: add an entry for Nicolas Schier
Date: Wed, 26 Mar 2025 21:13:55 +0100

Add mapping to linux.dev address as mail usage at work is limited and my
mail provider for private mails is suffering from its own domain name
block lists.

Link: https://lkml.kernel.org/r/20250326-mailmap-add-entry-for-nicolas-v1-1-3c26579a7fdf@fjasle.eu
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-an-entry-for-nicolas-schier
+++ a/.mailmap
@@ -549,6 +549,8 @@ Nicolas Pitre <nico@fluxnic.net> <nicola
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.com>
+Nicolas Schier <nicolas.schier@linux.dev> <n.schier@avm.de>
+Nicolas Schier <nicolas.schier@linux.dev> <nicolas@fjasle.eu>
 Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
 Nikolay Aleksandrov <razor@blackwall.org> <naleksan@redhat.com>
 Nikolay Aleksandrov <razor@blackwall.org> <nikolay@redhat.com>
_

Patches currently in -mm which might be from nicolas@fjasle.eu are


