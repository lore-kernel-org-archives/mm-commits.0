Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0E25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742262; cv=none; b=NQZBQ08qyQn7p9NIUVLbg4BD8n3OiBSnUyV320w37jtoChyP8HbAD2V1/seD0yqyyEWiwVELby57+9FKf9vHDdwlYDhoQ0MmWNDfOc+btDQ/mWXQY9Q0E/IHJunwEcl5aQplB10CNPUQkpsI6LWpPpSVzLZOKAnCFkH9e2V9Y8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742262; c=relaxed/simple;
	bh=EynMmAkqUd+vijgK77WnZAC5wqxH7cHxqGs5ht0w2Js=;
	h=Date:To:From:Subject:Message-Id; b=CBuxowmNIM03QX5Em2JOFxW7CHqmf9Ys9S54ZwNFSWtLXloRxcnBqOsVennMRlZonOpeWoWY7eB8mQARKd0JR44kdITMnaDfe69HHEcaanic8lWpPjme1RaMyHxkD1dbEPN9AdB8jpFeMcBl7gSt24lsLRJFm+eGfyEEbQ9A0v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v2esfhCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v2esfhCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09C7C4CED6;
	Mon, 13 Jan 2025 04:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742262;
	bh=EynMmAkqUd+vijgK77WnZAC5wqxH7cHxqGs5ht0w2Js=;
	h=Date:To:From:Subject:From;
	b=v2esfhCU4p7RPtGnBmDJd8bWlfXekjVxwBNndueJmXdpsQuYe3tDosoKXDZypoc/T
	 pCJz5545nTdx/ciyH02H659NBv9hH67+NW01Zga0cZk60P2VMU7CVSTgzvjILcU1f3
	 E40XaZGDwVRYdQY5zeTG9ZLEn6sFkhBWhjZbLWEg=
Date: Sun, 12 Jan 2025 20:24:21 -0800
To: mm-commits@vger.kernel.org,linus.luessing@c0d3.blue,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-entry-for-linus-lüssing.patch removed from -mm tree
Message-Id: <20250113042421.E09C7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Linus Lüssing
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-linus-lüssing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Lüssing <linus.luessing@c0d3.blue>
Subject: mailmap: update entry for Linus Lüssing
Date: Wed, 8 Jan 2025 04:58:39 +0100

Mapping another old, obsolete work email address to my primary one.

Link: https://lkml.kernel.org/r/20250108035840.25194-1-linus.luessing@c0d3.blue
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-linus-lüssing
+++ a/.mailmap
@@ -405,6 +405,7 @@ Liam Mark <quic_lmark@quicinc.com> <lmar
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
+Linus Lüssing <linus.luessing@c0d3.blue> <ll@simonwunderlich.de>
 <linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
_

Patches currently in -mm which might be from linus.luessing@c0d3.blue are


