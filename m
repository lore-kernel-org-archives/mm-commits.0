Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C051730AD0A
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280997; cv=none; b=AWeFu/HIe8ufKjK5cKNK08YrbGHE1DQw4W1D9Wm0FXTpvPZXDagqfX4AsK8soF8xKycUaSVNOMFYqHPtyD+aD3W+BaOSmn8Qb7Q1PWPUEqGM0tSFFoLIKHBio4c8RiMtG2PhFujYFO4MwAi4UOFct7WsC6IfFgaFWneEDmhQSoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280997; c=relaxed/simple;
	bh=REiLG1MrbHP0Wb4OpOA+Ik956lsAI+5osk1FSCjwj5U=;
	h=Date:To:From:Subject:Message-Id; b=ndLBYg40wNR+U+5d/O+vvXKzUQUEHAjV8oIFMVO/lkXrIeCNuwWE/71c9l5/yR8K7hAZbHxsgKXo6cc9ccycEpu6QV44af5QBgtBtlGp4X+FkBG+UMY5jf9//R70qfUr2qBkJ1fhDF9G6hp840TSXT71E3dQM5L7yw3gdd1gAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rEnfwPRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rEnfwPRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A1EC116C6;
	Tue, 13 Jan 2026 05:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280997;
	bh=REiLG1MrbHP0Wb4OpOA+Ik956lsAI+5osk1FSCjwj5U=;
	h=Date:To:From:Subject:From;
	b=rEnfwPRcDPdthWEUrOzcPYi8qWMookcVm1dS6dk9CxBHK6/eLiFGfDZgLYmHVtiQl
	 jRzEyeWhYZ2Sar/QiAiYCgx3R/oZjk1CeQRjL1756V4rkURr0FOTZNv8xzcXDH5R2X
	 oYrzXSzHhONW5xbxD+QV6H5Jh0UUVjr7oV5wn4o0=
Date: Mon, 12 Jan 2026 21:09:57 -0800
To: mm-commits@vger.kernel.org,danielt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-daniel-thompson.patch removed from -mm tree
Message-Id: <20260113050957.98A1EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Daniel Thompson
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-daniel-thompson.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Thompson <danielt@kernel.org>
Subject: mailmap: add entry for Daniel Thompson
Date: Thu, 08 Jan 2026 11:09:54 +0000

My linaro address stopped working a long time ago but I didn't update my
mailmap entry.  Fix that.

Link: https://lkml.kernel.org/r/20260108-mailmap-daniel_thompson_linaro-org-v1-1-83f610876377@kernel.org
Signed-off-by: Daniel Thompson <danielt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-daniel-thompson
+++ a/.mailmap
@@ -207,6 +207,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dborkmann@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dborkman@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
+Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from danielt@kernel.org are


