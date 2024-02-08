Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9077267A13
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369684; cv=none; b=D3CyIa4cbv6rk9oez5TbhXtffbipdmRODvlE8NJznRuaWOHospeOuG7GXcJlK4E849oXsQze2dAgt3Aa7i9X+9wp07g4roYEGmqDIZ4/X5eVTnLCTiagZRLJU7PBecS/HN2VsIZxSAdaGaVoOiCP6PikQxtwrMR5nET44OfrkDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369684; c=relaxed/simple;
	bh=OYYtYSVGLkT6oyskr1XG76PTALVxnsGZ9w7GyVC96Co=;
	h=Date:To:From:Subject:Message-Id; b=onv+Y1fljnfncZFhppXaGzUVNWrnH4a5Q6PCCeL2OHcKhPCzbLW/crSAorKvMRMg6kh08ghVp4NWkOeryHZXeq1EdywZiY1Fs4snvVS0tcCior+XRQ3lMCRanEQq4pnPJuR88giiW0APqKmjxcx7sNPU3ierC9THYJWuoQcN45I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3GElWbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3GElWbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C63C433C7;
	Thu,  8 Feb 2024 05:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369684;
	bh=OYYtYSVGLkT6oyskr1XG76PTALVxnsGZ9w7GyVC96Co=;
	h=Date:To:From:Subject:From;
	b=K3GElWbIC5nA+jvZpuI9l9FCBVb0cukH9K7ZYb0DEQh3yi71S7Yiag/D/YgkbCV1v
	 giyzmCbnm71kzwersCQOcGj1G1sjZsYqqbY7+W1WyrqWJLK+lk63t4kocB6E5M02Sn
	 GLcdDL/eyQqdInYU5rZQPNGloew7fa8BIik+Cdr8=
Date: Wed, 07 Feb 2024 21:21:23 -0800
To: mm-commits@vger.kernel.org,quic_tsoni@quicinc.com,quic_eberman@quicinc.com,john@jmoon.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-switch-email-address-for-john-moon.patch removed from -mm tree
Message-Id: <20240208052124.10C63C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: switch email address for John Moon
has been removed from the -mm tree.  Its filename was
     mailmap-switch-email-address-for-john-moon.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Moon <john@jmoon.dev>
Subject: mailmap: switch email address for John Moon
Date: Wed, 31 Jan 2024 03:43:18 +0000

Add current email address as QUIC email is no longer active.

Link: https://lkml.kernel.org/r/20240131034311.46706-1-john@jmoon.dev
Signed-off-by: John Moon <john@jmoon.dev>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-switch-email-address-for-john-moon
+++ a/.mailmap
@@ -289,6 +289,7 @@ Johan Hovold <johan@kernel.org> <johan@h
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
+John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
 <jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
_

Patches currently in -mm which might be from john@jmoon.dev are


