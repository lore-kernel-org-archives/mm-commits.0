Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92232BA42
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417988; cv=none; b=L0GBsJeRIzewpFYNw5f4d3Im7ik39Uk3EV76PiGSHsIlHH6XZ3r66FQIheDJj269KIcVmavZym6eN2D6y1Gqy09jYx4Qaw74uf7TDyaiVDgShYQ7Dzdvi6eG30u7BPKbdVhPtYsLT36ir6hE9b8kP5n4YdcSP8sP48pxPjRzWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417988; c=relaxed/simple;
	bh=WoQYQ1xPtXTa4oJRtwuUvs+Lin/4ihAvldvkVr8ZLgw=;
	h=Date:To:From:Subject:Message-Id; b=I/B5GkhiE92z5mzZpqvXXuU/uwpaAi9iYe75vjRgfuEF717VjvaD28vhy1qdxYJGHrTQVa9zI28QHamZ4bQhIx/zPMbV2ys8mX7xu2fyH06Tc+5CZP8JfPsxr0v3euCqQWgbdZU6JNOPn2jP/Y9OZgDunhEPb0RC/rRycHwMjIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNNcJRj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNNcJRj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB7CC4CEE2;
	Sat, 12 Apr 2025 00:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417988;
	bh=WoQYQ1xPtXTa4oJRtwuUvs+Lin/4ihAvldvkVr8ZLgw=;
	h=Date:To:From:Subject:From;
	b=jNNcJRj7l/QSJf5QBc0JSakS2q0H1pROasDCE3FBs2mk/4mXFnd2VK9sm9xHM1tRu
	 zhOuTgahpoXe4YHqk1gCsY1DD/b6ge0B7RcsTS+2AZDmsNLhYH1/oeWbGb1NFcD0k0
	 DpRjftAXlOP3kzxVZ2ASKcdG9yA71YOskUfypmt0=
Date: Fri, 11 Apr 2025 17:33:07 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,loic.poulain@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-loic-poulains-old-email-addresses.patch removed from -mm tree
Message-Id: <20250412003307.EAB7CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: map Loic Poulain's old email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-map-loic-poulains-old-email-addresses.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Subject: mailmap: map Loic Poulain's old email addresses
Date: Wed, 2 Apr 2025 15:01:37 +0200

Map old email addresses that are no longer in use.

Link: https://lkml.kernel.org/r/20250402130137.12328-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-map-loic-poulains-old-email-addresses
+++ a/.mailmap
@@ -438,6 +438,8 @@ Linus Lüssing <linus.luessing@c0d3.blue
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
+Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@linaro.org>
+Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@intel.com>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
_

Patches currently in -mm which might be from loic.poulain@oss.qualcomm.com are


