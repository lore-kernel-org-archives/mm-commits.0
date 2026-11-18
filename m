Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980530;
	b=roSo7bzSGnrIkbaGK2i2QhdNQZOVbQIufqMDI08GJLBovtv22MsSkgns39NwXuB5EhbF
	 XBfLvdXjz0uqzwYxx4UxKbVZ97wohrO8ZIhBRIEAzu6NS7UmUSUkrswGl9B2yTmYyUJuc
	 GvbA9eqoELUwUeii6e6baXbCwztwAk67AJCplQln3KARbjATbMDaY6eNYlErB9fcw+ufk
	 1lgD1MOca1/HoR+z7GTUigIfSliG4aqzKOdfmBJAXR1D6hr6yytXo55qm7cUBLBmgHDXw
	 A1UTV1wxhMU0HUpNsHO8YtYmvWfF6Jov3gpUpEHUvp47WvzEiH8cGqduYWuaRpoeoKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980530;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nkXTvDE6B3lxS96rkWg+ThWzOl5XQ4uxOW+ticKa/Ig=;
	b=fl9oAJldKk+T4G2IYaLZB+moAMn/VYVLwWBflPy+ikVw9RuvJ/Cx5w7KBn2zOUOJakgu
	 jDsLlSR/qbWZ1lWcs2VQGhvdzDBt24ZLa+u3xbK8a6ZVO0AchjCDxhsVanORRIiKaWbBM
	 YI0MVDi08U9w8M2wYr7bykZrqqrB9uq0YPsUbQBRXRmSe08rn68jsf/VvTlQhGEviAVzt
	 m18qKXiPvGBpIBHFr8fHMS/nOjjS0TMtPFv3IYFyql3YNP/rMHx17kyxyM/Hl165BHVhh
	 9RMgff657jpo+KVPWMZivm4Tg+/+lwil3IdRvlWUrPTWUaPM6fUc6az5MO8fUHGv+Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qyVJNVLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E63F606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qyVJNVLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0862A1F000C4;
	Wed, 18 Nov 2026 05:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980530;
	bh=nkXTvDE6B3lxS96rkWg+ThWzOl5XQ4uxOW+ticKa/Ig=;
	h=Date:To:From:Subject;
	b=qyVJNVLzrBomDPrW50Jye6HEzKKbkwcHdUcbK13+ulRQOIhwzXS9IfYvdwbH/lywL
	 nH/CEi0Jccr2KbEkMuBLzGkPv/NO1z8QAXDxSSaYPWCBecAgTkmwWewtX+L/I120hf
	 CsppHUryJyZG7nT+YtdeCheTKB/YpH8YR5wf0aH8=
Date: Tue, 17 Nov 2026 21:42:09 -0800
To: mm-commits@vger.kernel.org,jeff.johnson@oss.qualcomm.com,
	aluvala.sai.teja@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-update-email-address-for-sai-teja-aluvala.patch removed from -mm tree
Message-Id: <20261118054210.0862A1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: update email address for Sai Teja Aluvala
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-sai-teja-aluvala.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Subject: mailmap: update email address for Sai Teja Aluvala
Date: Tue, 17 Nov 2026 19:00:08 +0530

Map my former Qualcomm email address to my current Intel email address.

Link: https://lore.kernel.org/20261117133008.2560155-1-aluvala.sai.teja@intel.com
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-sai-teja-aluvala
+++ a/.mailmap
@@ -838,6 +838,7 @@ Rui Saraiva <rmps@joel.ist.utl.pt>
 Sachin Mokashi <sachin.mokashi@intel.com> <sachinx.mokashi@intel.com>
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
+Sai Teja Aluvala <aluvala.sai.teja@intel.com> <quic_saluvala@quicinc.com>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
 Sam Protsenko <semen.protsenko@linaro.org>
 Sam Protsenko <semen.protsenko@linaro.org> <semen.protsenko@globallogic.com>
_

Patches currently in -mm which might be from aluvala.sai.teja@intel.com are


