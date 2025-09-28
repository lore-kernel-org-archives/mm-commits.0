Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B6B216E1B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084641; cv=none; b=pgR7uqy9jvg8kkRw84XbFYvu/tIiBCoohEOY0nhy/Ajc8sfjSh69oia611RMBzUc/LkpS9IwuQJ1OLSSb0+EMwYUBbEwnHsxvU+XYY2ItT6NrnZ3qP4ZrUychMI502XbdPDOy1EmFVlmywrBZYkp5eOn2gi3IX35/s+E8zJ3qvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084641; c=relaxed/simple;
	bh=naHEZgESotbweqlgT9+EhBJWXIl47mftJkWpPUVIotQ=;
	h=Date:To:From:Subject:Message-Id; b=N1Ykzga6vDbmk/tsSbAhopkaL/yfI6rz6Natib3alUiiZOQ30oCGo/nevv8tp87VT+fz/UBwQcYlz7tOADVTM263XoPHQwNSvp3+/gZzHZ0N9QM3GYU/s8EH63/hqq7aSE37aNOMf5W/maRXqHP149Pgi2W7xfLU6ZmCii+BGAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OkmkHAEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OkmkHAEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456ECC4CEF0;
	Sun, 28 Sep 2025 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084641;
	bh=naHEZgESotbweqlgT9+EhBJWXIl47mftJkWpPUVIotQ=;
	h=Date:To:From:Subject:From;
	b=OkmkHAEuml4+K0y4hSDQEiRw7WKFJZRPbx5A152ukYs3sIdTPqv6Sgp7wbFZPvdIA
	 Aq3Ji7lRheZU2WeJevZTXWEuqZalcDZzPYyIIwHGI07XIANylOCQSL15sKyLl4xQfQ
	 uXFzktxRZseWslTGFLHDNfOEi1rY/Rd3i3nfjats=
Date: Sun, 28 Sep 2025 11:37:20 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,jarkko@kernel.org,carlos.bilbao@kernel.org,andersson@kernel.org,sibi.sankar@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-update-sibi-sankars-email-address.patch removed from -mm tree
Message-Id: <20250928183721.456ECC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Sibi Sankar's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-sibi-sankars-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Subject: MAINTAINERS: update Sibi Sankar's email address
Date: Fri, 26 Sep 2025 15:04:26 +0530

Switch to using oss.qualcomm.com email ID in the MAINTAINERS file.  Also
update mailmap to ensure proper attribution across historical commits.

Link: https://lkml.kernel.org/r/20250926093426.1735334-1-sibi.sankar@oss.qualcomm.com
Signed-off-by: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-sibi-sankars-email-address
+++ a/.mailmap
@@ -715,7 +715,8 @@ Shuah Khan <shuah@kernel.org> <shuahkhan
 Shuah Khan <shuah@kernel.org> <shuah.khan@hp.com>
 Shuah Khan <shuah@kernel.org> <shuahkh@osg.samsung.com>
 Shuah Khan <shuah@kernel.org> <shuah.kh@samsung.com>
-Sibi Sankar <quic_sibis@quicinc.com> <sibis@codeaurora.org>
+Sibi Sankar <sibi.sankar@oss.qualcomm.com> <sibis@codeaurora.org>
+Sibi Sankar <sibi.sankar@oss.qualcomm.com> <quic_sibis@quicinc.com>
 Sid Manning <quic_sidneym@quicinc.com> <sidneym@codeaurora.org>
 Simon Arlott <simon@octiron.net> <simon@fire.lp0.eu>
 Simona Vetter <simona.vetter@ffwll.ch> <daniel.vetter@ffwll.ch>
--- a/MAINTAINERS~maintainers-update-sibi-sankars-email-address
+++ a/MAINTAINERS
@@ -20710,7 +20710,7 @@ F:	Documentation/devicetree/bindings/pow
 F:	drivers/pmdomain/qcom/cpr.c
 
 QUALCOMM CPUCP MAILBOX DRIVER
-M:	Sibi Sankar <quic_sibis@quicinc.com>
+M:	Sibi Sankar <sibi.sankar@oss.qualcomm.com>
 L:	linux-arm-msm@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/mailbox/qcom,cpucp-mbox.yaml
_

Patches currently in -mm which might be from sibi.sankar@oss.qualcomm.com are


