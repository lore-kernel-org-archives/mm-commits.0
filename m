Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA5613635E
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577518; cv=none; b=gvivyECDkJVJ9/AAZhafaO68ae96C3xWHTeKujqyTm+uCBiZ56IQ/nTTxbICBZlzQq2QLoz4K0nRWXpRAsNwTZi0oSIcnOp5mT/M4DI5LEffLErfVV9uginqCQf5XGEv1OWOz0piJiDq1GlVUL/eQqxacbwZ1TF/UfR1Aoq3hbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577518; c=relaxed/simple;
	bh=+XAnSMfJQCGEXO9LwjmcwRIq1FOL8Bh90AVT2mydCeI=;
	h=Date:To:From:Subject:Message-Id; b=oei64/tKuKzaoYMddUUZAFU6n2MY/r7e5MPUjteviOMWBSw4OslwG5HiIOS5SL8Sh2fvfwXTffCv7dkYtI+5qcjsC4O/qoqkt426fzxfi5juulnfORzwAX/BCFoocyMzGk3QIC33eVntKQqNuXIyxyUyDtIoB6lbQKleEGWtT+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thsNvQ5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thsNvQ5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651BCC4CECD;
	Thu, 19 Dec 2024 03:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577516;
	bh=+XAnSMfJQCGEXO9LwjmcwRIq1FOL8Bh90AVT2mydCeI=;
	h=Date:To:From:Subject:From;
	b=thsNvQ5Hq2ISP5CqdxREsmn1ylmhODIGgjgMuPNvNsz1KIy3ntTV/WqsH4YLFkJyz
	 eu/0Ssn/lHZ9n8KbRiG9DOCPlNqgTn9OtySqcuT/1Gbu4gTrRGHUX1yC5UBI5vinCY
	 VIWY9ZUaUEyXc7Pp3d0zo4xEl7NJ9xJM96AmobHE=
Date: Wed, 18 Dec 2024 19:05:15 -0800
To: mm-commits@vger.kernel.org,huang.ying.caritas@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-ying-huang.patch removed from -mm tree
Message-Id: <20241219030516.651BCC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Ying Huang
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-ying-huang.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mailmap: add entry for Ying Huang
Date: Thu, 5 Dec 2024 20:42:01 +0800

Map my old company email to my personal email.

Link: https://lkml.kernel.org/r/20241205124201.529308-1-huang.ying.caritas@gmail.com
Signed-off-by: "Huang, Ying" <huang.ying.caritas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-ying-huang
+++ a/.mailmap
@@ -735,6 +735,7 @@ Wolfram Sang <wsa@kernel.org> <w.sang@pe
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
+Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are


