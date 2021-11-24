Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9D0C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhKXDKr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:10:47 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:36425 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhKXDKr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Nov 2021 22:10:47 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HzQt02qLlz4xcK;
        Wed, 24 Nov 2021 14:07:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637723256;
        bh=VfQlwvKjJzKN70mF3EQztLYg3JVR9jGUdJHHCu5LuJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BDSgo2mnWZEw9nhWP/VIVCYvmH4vSfOSAg+iW1bCPzo1+ZmImKBna8IhhvCeOufov
         XYZ7Ql75iu1G8nZFFAcbuWkpZPIdLeqJaJjUiDtSEmpP4NA7sqzUvYeDtstNgEheIG
         Hsd9QpqaYx2Ln6xMN4Erh6PTw44v1AEy8Rqj36hiXo1e/FYO73sVIjzcbkvHJcAy0O
         Hr3jrQ8R1vfnq38/hr7Z2eYn0FOBMUVwSIfDKeHOy8cJdi4QdpGoekl6cvmRyKfG7l
         /dpWg0d+gHVws2WMj/FEAAW+5IwC3XzbEkcM3f8R9l/CogKa99JZhJ/++1eBe4TWPZ
         xobYPmtw9dPTA==
Date:   Wed, 24 Nov 2021 14:07:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     ccross@google.com, mm-commits@vger.kernel.org, surenb@google.com
Subject: Re: +
 mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch added
 to -mm tree
Message-ID: <20211124140734.07b093b4@canb.auug.org.au>
In-Reply-To: <20211124002029.xqAm4tts2%akpm@linux-foundation.org>
References: <20211124002029.xqAm4tts2%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TvoRx5bC6YhrYsIRWh4Qi_h";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/TvoRx5bC6YhrYsIRWh4Qi_h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 23 Nov 2021 16:20:29 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: docs: proc.rst: /proc/PID/maps: fix malformed table
> has been added to the -mm tree.  Its filename is
>      mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/TvoRx5bC6YhrYsIRWh4Qi_h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGdrHYACgkQAVBC80lX
0Gz7MQf7B+K8tAoghLExLKpaoFlhGqN1Hr3hxlP0NeZe8jlTegRLdsiP44v6Sa40
TAbuo3hOfzXM/zR0rw/kJj3avfXbb8Fscw6AjAxcOZaubevitvWRZT9EAdk0QLpR
BYifiLUG10I2ldRDQoy25g9ftonLk0RRb0HlLUGY5vVyieNNZlpI4WNQ07HthOR2
pIW0HwPuhnThWUTmalTYN5/j0tY0HEF9fvAMw8rs6bdnK3fvpYmpfCJiPMXjVy7l
+xb8Om6hx44ytynDq4hMaC/HFmpjCbbohqPlO4j4faoxRc3rNw/m5EABU4mzyanQ
yi9ACsVgfyxq3UbaRKaBFcsD0QOskQ==
=pecw
-----END PGP SIGNATURE-----

--Sig_/TvoRx5bC6YhrYsIRWh4Qi_h--
