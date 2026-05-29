Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBD37269C
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028798; cv=none; b=XOBC2V10Xkcutsn4FPFJkjdlEEmycoadCCmq3uHZyvwC8ILdw2zrWFSo1PA0ZpJCgVE8KUm4JwwKya5aKT8Ve4geQkfVuVVyS2sXjrHITwdyjCaipX8SEUONKx2nVntyCWiGIlj6fjyi++/6eLUxWgY5V/0VblwPVdVt5lEjfvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028798; c=relaxed/simple;
	bh=s7UTC5LbMjLoqC3T6yVisV6V3ToseRba+gKMwt/R5as=;
	h=Date:To:From:Subject:Message-Id; b=jPzhOdpEo0c6Ns2uDijbVLBEridMhzlKhUSzHmL9mszbS5yhhDmK682hHgblNSGsw20RIWKyK8ckQvvxqToo1bko/XtkFHUj1OiQYdOU915+hF7FUBs829RL6wV0d5ujwj1yTe+k4sCtfK2EF3Q/tY4AoEVeL+zx2MZJCVwiW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvqfMotA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvqfMotA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4D71F00898;
	Fri, 29 May 2026 04:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028796;
	bh=zT5Is+0jSq+JiNYrUrgH4XIA0N3GpwSjfwd7yEzOsLI=;
	h=Date:To:From:Subject;
	b=zvqfMotA3M/UOslAvc9bnvy2BgFgM6hS5rRELx8FGEuV1GlQ3aEKSloKTIGLKRAFz
	 S91mKkd1jC9m3z5PgId3cSSgISuWSKjSoVPQLVJn82ExPKrIyGx4TiGkNO9h1DlXlH
	 iuKU45oCfKB8tuKLH2WsyxpJbExyup+BmFWE3aUg=
Date: Thu, 28 May 2026 21:26:35 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,martink@posteo.de,kuba@kernel.org,konradybcio@kernel.org,jorge.ramirez@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-jorge-ramirez-ortiz-email-address.patch removed from -mm tree
Message-Id: <20260529042636.2E4D71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Jorge Ramirez-Ortiz email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-jorge-ramirez-ortiz-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Subject: mailmap: update Jorge Ramirez-Ortiz email address
Date: Mon, 18 May 2026 11:10:05 +0200

Map old Linaro address to the new Qualcomm OSS address.

Link: https://lore.kernel.org/20260518091019.3926371-1-jorge.ramirez@oss.qualcomm.com
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-jorge-ramirez-ortiz-email-address
+++ a/.mailmap
@@ -435,6 +435,7 @@ John Stultz <johnstul@us.ibm.com>
 Jonas Gorski <jonas.gorski@gmail.com> <jogo@openwrt.org>
 Jonathan Cameron <jic23@kernel.org> <jonathan.cameron@huawei.com>
 Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
+Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com> <jorge.ramirez-ortiz@linaro.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from jorge.ramirez@oss.qualcomm.com are


