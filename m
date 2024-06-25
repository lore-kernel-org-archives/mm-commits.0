Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611973448
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287563; cv=none; b=jGaXIp6O4jprZCuFPLUxKaRXs6fLrnxHukqW81ebdi7DuHghbOBk4Un0X+TQ0pITbBdTwune6P/WL447DyVNpKLHHCmq1dyMOOJ6skHrXwNkez9CyQRhmwfBfiA+hdCL/D/D7Fqhh5dWuMRFWCtuCmASRrRc0EDnpzEzJGznjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287563; c=relaxed/simple;
	bh=lzPLWXx/go+nTE2pVwL7ybkFzyOLdEZ1si3Z/n2AadA=;
	h=Date:To:From:Subject:Message-Id; b=L9uMdkMTv1yMOkQQwAhEFgahkKzf7CD5per5FxdmVlqpHlxt7Yhi84W+AzrSGztA0uJ+byzZdW7bf1w5hafC8mN8WgL3ILoV9fOehv6TFV2rRdfbKsUmFTiieFU6sjWGXfu6g9c+M17y5VaZFRWBIhi1Ilzk/RgQpa7fOOAbhE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I+4LxqGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I+4LxqGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6801DC4AF07;
	Tue, 25 Jun 2024 03:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287563;
	bh=lzPLWXx/go+nTE2pVwL7ybkFzyOLdEZ1si3Z/n2AadA=;
	h=Date:To:From:Subject:From;
	b=I+4LxqGjonAv0gJZAJ2eoncSP+MKcFVdBu1yz61lmrnSCnXlIhYumiz96T+5ixxWN
	 DOMbICJgpMaiL6HBiBhu4AzpDuPpOzobMfGGlPPB4hGZc6TeGiy1zOI/LJ7MSr/vJ3
	 gL3FIWEATgVZTrYtgLAz9H1eS4TRtE6pdwd//79o=
Date: Mon, 24 Jun 2024 20:52:42 -0700
To: mm-commits@vger.kernel.org,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-tpm-device-driver-update-the-w-tag.patch removed from -mm tree
Message-Id: <20240625035243.6801DC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
has been removed from the -mm tree.  Its filename was
     maintainers-tpm-device-driver-update-the-w-tag.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
Date: Tue, 18 Jun 2024 16:35:56 +0300

Git hosting for the test suite has been migrated from Gitlab to Codeberg,
given the "less hostile environment".

Link: https://lkml.kernel.org/r/20240618133556.105604-1-jarkko@kernel.org
Link: https://codeberg.org/jarkko/linux-tpmdd-test
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-tpm-device-driver-update-the-w-tag
+++ a/MAINTAINERS
@@ -22745,7 +22745,7 @@ M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Jason Gunthorpe <jgg@ziepe.ca>
 L:	linux-integrity@vger.kernel.org
 S:	Maintained
-W:	https://gitlab.com/jarkkojs/linux-tpmdd-test
+W:	https://codeberg.org/jarkko/linux-tpmdd-test
 Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
 F:	Documentation/devicetree/bindings/tpm/
_

Patches currently in -mm which might be from jarkko@kernel.org are


