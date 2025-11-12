Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0E14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908609; cv=none; b=g6wYXdpwHgCsipm4bAFHatu6IkWbrJ4/96O61eLbk7QRR1Qr+KNfCfCyKtmj5Vbci8H89TlDFsmHj/fgYvXYPYPnbHWH6JauSsN7Sfs64Fj+U3EFISbSK3tc2x3DmtpoAq8OHf3bM5cUhjM0JlDhC9G6bBWecs3t5dybhxaS3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908609; c=relaxed/simple;
	bh=+9reBrMGCXnxfymJAJN95D98pYcWdVFPBHsJYmxzxI0=;
	h=Date:To:From:Subject:Message-Id; b=UWn9P9IyWgNJrd5rHJQa/DSjPpEgvmGkrZFdfMzVh9z50Kl3b337KuvuJdAj8WxIdzsbHzzO355JgyLUXF/desu1nTWltZ0XQPnQaBK9m4TTZPyDNcz720IOi6+7rgpYO0FQleBpeQfki9rcrti/JeMYvN33i5kjyOo8I7RCjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRd1dQzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRd1dQzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA8CC16AAE;
	Wed, 12 Nov 2025 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908609;
	bh=+9reBrMGCXnxfymJAJN95D98pYcWdVFPBHsJYmxzxI0=;
	h=Date:To:From:Subject:From;
	b=MRd1dQzZ5DI7DsYw3zKKgQwgEESW43D5hDlGvrgX1qZhX1LCt2GKYGcpSZ7usofdo
	 K0hGdbSIAVsNkZ2TV/K/hQ5u1dDD7Bs3FEzI2Q1C/FLQ4uASIr/1UhS77WlG0ILA9y
	 jc+SlsLy77feNMYyiBI2Fyjp4VB0YELZudX/ocjk=
Date: Tue, 11 Nov 2025 16:50:08 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,stanley_chang@realtek.com,eleanor.lin@realtek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entry-for-yu-chun-lin.patch removed from -mm tree
Message-Id: <20251112005009.0DA8CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Yu-Chun Lin
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-yu-chun-lin.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu-Chun Lin <eleanor.lin@realtek.com>
Subject: mailmap: add entry for Yu-Chun Lin
Date: Mon, 27 Oct 2025 18:03:09 +0800

Map my personal email to my business email.

Link: https://lkml.kernel.org/r/20251027100309.22035-1-eleanor.lin@realtek.com
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Stanley Chang <stanley_chang@realtek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-yu-chun-lin
+++ a/.mailmap
@@ -856,6 +856,7 @@ Yakir Yang <kuankuan.y@gmail.com> <ykk@r
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
_

Patches currently in -mm which might be from eleanor.lin@realtek.com are


