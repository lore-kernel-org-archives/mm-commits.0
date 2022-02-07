Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F40C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 22:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbiBGWvs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiBGWvs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 17:51:48 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042F1C061355
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 14:51:45 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jt1bd2xSsz4xdG;
        Tue,  8 Feb 2022 09:51:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644274301;
        bh=/ezpZ+4zBsOA/S2ZdyKoG53A2KFId8l28VTGMM4yQBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RwihhkLnzUJXhkeR8JSuwWEdI44mjBBMqaKMhxxtKjNeKh1sfvorS1rCN8VL6051c
         6GBRGzeFN+aKHbrB8SbjCKvVvyvKh1rVkLGRUaJBOfs+4sYkqBNsvtfMJDZbD0qR4c
         wdME9Hw1mbtAqaA0bTYLnpHaKHRdlKhq0mQ4VXg7gbKkqABoOA0OydEdeurIi+Hmab
         vuDlJyrcZP8iY68BmMsdnotIX36O/VeAiPShAumgHT06Wan/3jnSmWl0HJmjl0dV82
         yoZyvKkIlULzZRtdqsATMkf/zrWJfaFwZbXL+z4jTDNgkmXEnHrmRWdPNYqt1MMhK/
         ZPaoygzg+ejmg==
Date:   Tue, 8 Feb 2022 09:51:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, neilb@suse.de, jack@suse.cz,
        colin.i.king@gmail.com
Subject: Re: +
 remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch
 added to -mm tree
Message-ID: <20220208095139.0a683953@canb.auug.org.au>
In-Reply-To: <20220207210022.210D1C004E1@smtp.kernel.org>
References: <20220207210022.210D1C004E1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AvFNQ+YveNMzcCg3ddhMfIe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/AvFNQ+YveNMzcCg3ddhMfIe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 07 Feb 2022 13:00:21 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The patch titled
>      Subject: ext2: remove unused pointer bdi
> has been added to the -mm tree.  Its filename is
>      remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.pa=
tch

Applied to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/AvFNQ+YveNMzcCg3ddhMfIe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIBonsACgkQAVBC80lX
0GzOqQf/ZeBfDhMMksHYW7bq2YVh2S0GVjccbIa5/NBRYi1cubPZ9ShHW0oAedoI
/9D9NgmkxTnJYq6nJlVGioIDE0dMtIAmx5grf87a0y4lSSUP3fZjjV9TZQM1R2NZ
9i1WApkr+K1cF2VFtRbypFfNsdqethZTR92oYa0mqwC+akb6bgq1+CT2cC2IqQS6
uxjc747eVOrTx/fNVHLY6hiG1CMtwjrahv8Dt2esMMMFcY07sYLu9EsvcyXvllnh
4pUQp172ZxZQnm2FashM4C7QCIKoK+b3ZgyoY5mf4OB+8ik+6Xs6bFXq82GKWzvy
+l0qA5j33TEB4eTgwiZIo72NGM0iog==
=mIl/
-----END PGP SIGNATURE-----

--Sig_/AvFNQ+YveNMzcCg3ddhMfIe--
